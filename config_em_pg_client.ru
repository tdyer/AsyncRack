require 'rubygems'
require 'rack/async'
require 'eventmachine'
require 'pg/em'

# require 'ruby-debug19'
# Debugger.start

class EMAsyncApp
  attr_accessor :method_to_invoke

  def initialize(options={ })
    # puts "EMASyncApp#initialize"
    @method_to_invoke = options[:method] || "no_method_to_invoke"
  end

  # TODO: not used but shd do a default method dispatch
  # prob doesn't work with the map calls below??
  # def method_missing(method, env)
  #   req = Rack::Request.new(env)
  #   # show the path that we're trying to dispatch to
  #   method  = req.path_info.split('/')[1]
  #   # puts "method_missing: try to call method #{method}"
  #   #  puts "WTF: there ain't no stinking method named #{method} DUDE"
  #   #"\nWTF: there ain't no stinking method named #{method} DUDE\n" 
  # end

  def call(env)
    # puts "@method_to_invoke = #{@method_to_invoke}"
    send(@method_to_invoke, env)
  end

  
  # Plain ole rack handler
  def rack_standard(env)
    @req = Rack::Request.new(env)
    # puts "here in standard rack handler"
    @res = Rack::Response.new
    @res.write("Hey from a standard rack app")
    @res.finish
  end

  # simulate fire and forget
  # fire a simulated blocking DB call, simulated wth EM.add_timer(5) 
  def rack_async(env)
    event_machine do
      # each new client connection will get this response
      env['async.callback'].call([200, {}, ["Hey from a ASync Rack app!!!!!!!"]])

      # and it will start a deferred job that will fire in 5 seconds
      EM.add_timer(5) do
        # puts "yeehaaa going to DB!!!!!"
      end
    end
    # returning this signals to the server we are sending an async
    # response
    Rack::Async::RESPONSE
  end

  def self.conn
    unless @conn
      @conn = PG::EM::Client.new(:dbname => 'ourstage_development')
      @conn.setnonblocking(true)      
    end
    @conn
  end

  def db_async(env)

    event_machine do
      pg = self.class.conn
      # each new client connection will get this response immediately
      env['async.callback'].call([200, {}, ["Hey from a DB ASync Rack app!!!!!!!"]])

      # Make the non-blocking/async query, returns a EM::Deferrable
      df = pg.query('select * from categories')
      df.callback { |result|
        puts "EMAsyncApp::db_async DB results = #{Array(result).inspect}"
      }
      df.errback {|ex|
        puts "EMAsyncApp::db_async Exeption = #{ex.inspect}"
        raise ex
       }

    end

    puts "EMAsyncApp::db_async returning"
    
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
use Rack::Async

map "/rack" do
  run EMAsyncApp.new(:method => 'rack_standard')
end

map "/rack_async" do
  run EMAsyncApp.new(:method => 'rack_async')
end

map "/db_async" do
  run EMAsyncApp.new(:method => 'db_async')
end

# start this rack app with thin on port 8111
# thin --rackup config.ru start -p 8111 -V

