require 'rubygems'
require 'yaml'
require 'erb'
require 'rack/async'
require 'eventmachine'
require 'em-postgres'

# start up on port 8111
# thin --rackup config.ru start -p 8111

# test 100 HTTP POST requests by 50 users
# ab -n 100 -c 50 -p tracker_heartbeat_post_data -T 'application/x-www-form-urlencoded' http://127.0.0.1:8111/tracker/heartbeat 

# Data to POST is in tracker_heartbeat_post_data:
# session_id=1234&user_id=33&activity=dummy_activity&beat=44

class TrackerHeartbeat
  attr_accessor :query

  def self.conn
    unless @conn
      # open the database config file
      db_config = YAML.load(ERB.new(File.read("config/stats_database.yml")).result )

      # Set the environment, development, test or production
      # development (the default)
      # thin --rackup config.ru start -p 8111
      # production
      # thin --rackup config.ru start -p 8111 -e production
      environment = ENV['RACK_ENV']

      # puts "Rack environment is #{environment.inspect}"
      # puts "db_config = #{db_config[environment].inspect}"
      database = db_config[environment]['database']
      puts "Connecting to database = #{database.inspect}"
      @conn = EventMachine::Postgres.new(:database => database)
      @conn.setnonblocking(true) # may not be needed?     
    end
    @conn
  end


  def call(env)
    event_machine do
      req = Rack::Request.new(env)

      session_id = req.params['session_id']
      user_id = req.params['user_id']
      activity = req.params['activity']
      ip_addr = req.ip
      referrer = req.referrer || ""
      created_at = Time.now
      beat = req.params['beat']

      query = "INSERT INTO heartbeats (session_id, user_id, activity, ip_addr, referrer, created_at, beat) VALUES (\'#{session_id}\', \'#{user_id}\', \'#{activity}\', \'#{ip_addr}\', \'#{referrer}\', \'#{created_at}\', \'#{beat}\');"

      # get the DB connection
      pg = TrackerHeartbeat.conn

      puts "TGD: query is #{query}"
      # Make the non-blocking/async query, returns a EM::Deferrable
      df = pg.execute(query)

      # signal to the web server, Thin, that it's HTTP request will be
      # handled asynchronously. It will not block
      env['async.callback'].call([200, {}, ["Tracker Heartbeat!!!!!!!"]])

      # success callback
      df.callback { |result|
        puts "TrackerHeartbeat::call DB results = #{Array(result).inspect}"
      }

      # error callback
      df.errback {|ex|
        puts "TrackerHeartbeat::call Exception = #{ex.inspect}"        
        raise ex
      }

    end
    # returning this signals to the server we are sending an async
    # response
    Rack::Async::RESPONSE
  end
    private
  # make sure EventMachine is running (if we're on thin it'll be up
  # and running, but this isn't the case on other servers).
  def event_machine(&block)
    if EM.reactor_running?
      # puts "Reactor is running!"
      block.call
    else
      # puts "Reactor is NOT running!"
      Thread.new {EM.run}
      EM.next_tick(block)
    end
  end

end
