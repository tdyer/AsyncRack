require 'rubygems'
require 'rack/async'
require 'eventmachine'

class EMAsyncApp
  attr_accessor :method_to_invoke
  attr_accessor :my_count

  def initialize(options={ })
    puts "EMASyncApp#initialize"
    @method_to_invoke = options[:method] || "no_method"
  end

  # method dispatch
  def method_missing(method)
    # show the path that we're trying to dispatch to
    method  = @req.path_info.split('/')[1]

    puts "WTF: there ain't no stinking method named #{method} DUDE"
    "\nWTF: there ain't no stinking method named #{method} DUDE\n" 
  end

  # shd map to '/'
  def root
    "<html><body>Root of the side, </body></html>"
  end

  # standard rack handler
  def call(env)
    # sleep(5)
    @req = Rack::Request.new(env)
    content = send(@method_to_invoke)
    puts "here in standard rack handler"
    @res = Rack::Response.new
    @res.write(content)
    @res.finish

    # [200, {"Content-Type" => "text/html"}, ["Hello world!"]]
  end


  def callxxx(env)
    event_machine do
      EM.add_timer(5) do
        puts "heyyyyyyyyyyyyyyyyyyyy"
        env['async.callback'].call([200, {}, ["Hello world!"]])
      end
    end
        # returning this signals to the server we are sending an async
    # response
    Rack::Async::RESPONSE
  end

  private
    # make sure EventMachine is running (if we're on thin it'll be up
  # and
  # running, but this isn't the case on other servers).
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

#puts "timer count #{EventMachine.get_max_timer_count}"
#EventMachine.set_max_timers(1000)
use Rack::Async

map "/" do
  run EMAsyncApp.new(:method => 'root')
end
