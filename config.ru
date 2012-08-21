require 'rubygems'
require 'rack/async'
require './em_async_app'

use Rack::Async

map "/rack" do
  run EMAsyncApp.new(:method => 'rack_standard')
end

map "/rack_async" do
  run EMAsyncApp.new(:method => 'rack_async')
end

map "/db_async" do
  run EMAsyncApp.new(:method => 'db_async', :query => 'select count(*) from categories')
end

# start this rack app with thin on port 8111
#  thin --rackup config.ru start -p 8111

# same as above but logging request/response (much slower!)
# thin --rackup config.ru start -p 8111 -V

# run one request as one user
# ab -n 1 -c 1 http://127.0.0.1:8111/rack_async
# run 2 requests for each of the 50 users
# ab -n 100 -c 50 http://127.0.0.1:8111/rack_async
