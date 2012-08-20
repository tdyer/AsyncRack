require 'rubygems'
require 'rack'
require 'eventmachine'
require 'pg/em'

$conn = nil
$query = 'select count(*) from categories'
# puts "Connection is " << (conn.is_busy ? "busy" : "not busy")
#puts "Connection defaults = #{conn.conndefaults().inspect}"
#sleep 2

my_app = lambda do |env|
  EM.run do

    # opening the connection ONCE
    unless $conn
      $conn = PG::EM::Client.new(:dbname => 'ourstage_development')      
      $conn.setnonblocking(true)
    end

    # puts "TGD: Connection is #{$conn.inspect}"
    # puts "TGD: Connection is " << ($conn.is_busy ? "busy" : "not busy")

    puts "START"
    
    # each new client connection will get this response
    env['async.callback'].call([200, {}, ["Starting the query!!!!!!!"]])

    puts "about to do my query"
    # NOTE: This will fail with a "PG::Error: another command is
    # already in progress" if a previous query has not completed.
    # Seems that postgres will return from the call to submit the SQL
    # immediately in non-blocking mode. But will NOT
    # accept another query until the results of the previous query
    # have been read, completely!
    df = $conn.query($query)
    df.callback { |result|
      puts "result is #{Array(result).inspect}"
      EM.stop
    }
    df.errback {|ex|
      puts "TGD: Error is #{ex.inspect}"
      raise ex
    }
    
    puts "End"
  end
end

Rack::Handler::Thin.run my_app, :Port => 8888

