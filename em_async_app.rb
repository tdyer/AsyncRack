require 'rack/async'
require 'eventmachine'
require 'em-postgres'

# require 'ruby-debug19'
# Debugger.start

class EMAsyncApp
  attr_accessor :method_to_invoke, :query

  def initialize(options={ })
    # puts "EMASyncApp#initialize"
    @method_to_invoke = options[:method] || "no_method_to_invoke"
    @query = options[:query] || "select count(*) from categories"
  end

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
      @conn = EventMachine::Postgres.new(:database => 'ourstage_development')
      @conn.setnonblocking(true) # may not be needed?     
    end
    @conn
  end

  def db_async(env)

    event_machine do
      # get the DB connection
      pg = EMAsyncApp.conn

      # signal to the web server, Thin, that it's HTTP request will be
      # handled asynchronously. It will not block
      env['async.callback'].call([200, {}, ["Hey from a DB ASync Rack app!!!!!!!"]])

      # Make the non-blocking/async query, returns a EM::Deferrable
      df = pg.execute(query)

      # success callback
      df.callback { |result|
        puts "EMAsyncApp::db_async DB results = #{Array(result).inspect}"
      }

      # error callback
      df.errback {|ex|
        puts "EMAsyncApp::db_async Exeption = #{ex.inspect}"
        raise ex
       }

    end
    # puts "EMAsyncApp::db_async returning"
    
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
