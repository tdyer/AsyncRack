require 'rubygems'
require 'rack/async'
require 'eventmachine'

class EMAsyncApp
  def call(env)
    [200, {"Content-Type" => "text/html"}, ["Hello world!"]]
  end
  
  def callxxx(env)
    event_machine do
#      EM.add_timer(5) do
        env['async.callback'].call([200, {}, ["Hello world!"]])
#      end
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
      block.call
    else
      Thread.new {EM.run}
      EM.next_tick(block)
    end
  end
end

use Rack::Async
run EMAsyncApp.new
