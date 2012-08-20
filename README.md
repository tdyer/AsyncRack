- em_postgres_toy.rb (This is the gem we'll use!)
  A rack app that will use the ruby-em-pg-client gem to make non-blocking* request
  to postgres. 
  Pretty much the same as the em_pg_client.rb EXCEPT that it implements a queue where each SQL call 
  to postgres will be queued until the previous SQL call's result has been totally read.

  NOTE: this gem does NOT include the dependency on the pg gem. You must add "gem 'pg'" to 
  you're Gemfile

- config.ru
  A more complex rack app that has a couple of routes and uses the em_pg_client gem. 
  

- em_pg_client.rb (Won't work for multiple SQL commands!!)
  A rack app that will use the ruby-em-pg-client gem to make non-blocking* request
  to postgres. 
  https://github.com/royaltm/ruby-em-pg-client
  * Postgres can NOT handle multiple request per connection!!! 
  This gem will send a "send_query" request to postgres and return immediately
  But, one can NOT invoke another send_query request until the previous send_query's 
  result is totally read. This is because the result is sent back on the same file
  descriptor that was used by the connection and the send_query command. 

  I would've like it if postgres did a true async mode. Different FD's for connection, command
  and result set, oh well.

- config_em_pg_client.ru (Won't work for multiple SQL commands!!)
  A more complex rack app that has a couple of routes and uses the em_pg_client gem. 


  
  



  
