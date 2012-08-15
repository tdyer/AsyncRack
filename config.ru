require 'rubygems'
require 'rack/async'
require 'eventmachine'

class EMAsyncApp
  attr_accessor :method_to_invoke

  def initialize(options={ })
    # puts "EMASyncApp#initialize"
    @method_to_invoke = options[:method] || "no_method_to_invoke"
  end

  # TODO: not used but shd do a default method dispatch
  # prob doesn't work with the map calls below??
  def method_missing(method, env)
    req = Rack::Request.new(env)
    # show the path that we're trying to dispatch to
    method  = req.path_info.split('/')[1]
    puts "method_missing: try to call method #{method}"
    #  puts "WTF: there ain't no stinking method named #{method} DUDE"
    #"\nWTF: there ain't no stinking method named #{method} DUDE\n" 
  end

  def call(env)
    puts "@method_to_invoke = #{@method_to_invoke}"
    send(@method_to_invoke, env)
  end

  
  # Plain ole rack handler
  def rack_standard(env)
    @req = Rack::Request.new(env)
    puts "here in standard rack handler"
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
        puts "yeehaaa going to DB!!!!!"
      end
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
use Rack::Async

map "/rack" do
  run EMAsyncApp.new(:method => 'rack_standard')
end

map "/rack_async" do
  run EMAsyncApp.new(:method => 'rack_async')
end


# start this rack app with thin on port 8111
# thin --rackup config.ru start -p 8111 -V


# 1 request by 1 user/client to a standard rack app
# //usr/sbin/ab -n 1 -c 1 http://127.0.0.1:8111/rack
# 1 request by 1 user/client to a ASYNC rack app
# /usr/sbin/ab -n 1 -c 1 http://127.0.0.1:8111/rack_async

# 1000 request by 10 user/clients
# /usr/sbin/ab -n 1000 -c 10 http://127.0.0.1:8111/rack_async
# This is ApacheBench, Version 2.3 <$Revision: 655654 $>
# Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
# Licensed to The Apache Software Foundation, http://www.apache.org/

# Benchmarking 127.0.0.1 (be patient)
# Completed 100 requests
# Completed 200 requests
# Completed 300 requests
# Completed 400 requests
# Completed 500 requests
# Completed 600 requests
# Completed 700 requests
# Completed 800 requests
# Completed 900 requests
# Completed 1000 requests
# Finished 1000 requests


# Server Software:        thin
# Server Hostname:        127.0.0.1
# Server Port:            8111

# Document Path:          /rack_async
# Document Length:        32 bytes

# Concurrency Level:      10
# Time taken for tests:   2.558 seconds
# Complete requests:      1000
# Failed requests:        0
# Write errors:           0
# Total transferred:      107000 bytes
# HTML transferred:       32000 bytes
# Requests per second:    390.99 [#/sec] (mean)
# Time per request:       25.576 [ms] (mean)
# Time per request:       2.558 [ms] (mean, across all concurrent requests)
# Transfer rate:          40.86 [Kbytes/sec] received

# Connection Times (ms)
#               min  mean[+/-sd] median   max
# Connect:        0    0   0.4      0       4
# Processing:     1   25  39.7      4     158
# Waiting:        0   20  36.5      3     158
# Total:          1   26  39.6      4     158

# Percentage of the requests served within a certain time (ms)
#   50%      4
#   66%      5
#   75%     23
#   80%     55
#   90%    102
#   95%    105
#   98%    149
#   99%    158
#  100%    158 (longest request)
