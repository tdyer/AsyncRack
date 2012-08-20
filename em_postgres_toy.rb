require 'rubygems'
require 'rack'
require 'eventmachine'
require 'em-postgres'

$conn = nil
$query = 'select count(*) from categories'
# puts "Connection is " << (conn.is_busy ? "busy" : "not busy")
#puts "Connection defaults = #{conn.conndefaults().inspect}"
#sleep 2

my_app = lambda do |env|
  EM.run do

    # opening the connection ONCE
    unless $conn
      $conn =  EventMachine::Postgres.new(:database => 'ourstage_development')
      $conn.setnonblocking(true)
    end

    # puts "TGD: Connection is #{$conn.inspect}"
    # puts "TGD: Connection is " << ($conn.is_busy ? "busy" : "not busy")

    puts "START"
    
    # each new client connection will get this response
    env['async.callback'].call([200, {}, ["Starting the query!!!!!!!"]])

    puts "about to do my query"
    df = $conn.execute($query)
    df.callback { |result|
      puts "result is #{Array(result).inspect}"
      # EM.stop
    }
    df.errback {|ex|
      puts "TGD: Error is #{ex.inspect}"
      raise ex
    }
    puts "End"
  end
end

Rack::Handler::Thin.run my_app, :Port => 8888

