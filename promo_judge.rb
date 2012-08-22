require 'rubygems'
require 'yaml'
require 'erb'
require 'rack/async'
require 'eventmachine'
require 'em-postgres'
require 'json'

# Start server will log to log/development.log
# thin --rackup config.ru start -p 8111

# run apachebench with 1 request and 1 user/connection
# send a XHR POST request with the request params in the promo_click_data file.
# -v 2 is verbose logging
# -C promo_code='noisepop' is a Cookie
# ab -n 1 -c 1 -C promo_code='noisepop' -p promo_click_data -T 'application/x-www-form-urlencoded' -H "X-Requested-With: XMLHttpRequest" http://127.0.0.1:8111/api/promo_judge/click

class PromoJudge
  attr_accessor :method_to_invoke, :logger, :environment, :current_promotion
  
  def initialize(opts = { })
    @method_to_invoke = opts[:method]
    @logger = opts[:logger]
    @environment = opts[:environment]
  end
  
  # create the DB connection
  def conn
    unless @conn
      # open the database config file
      db_config = YAML.load(ERB.new(File.read("config/ourstage_database.yml")).result )
      database = db_config[environment]['database']
      @conn = EventMachine::Postgres.new(:database => database)
      @conn.setnonblocking(true) # may not be needed?     
    end
    @conn
  end


  def call(env)
    send(@method_to_invoke, env)
  end

  def click(env)
    @req = Rack::Request.new(env)

    # assert that this is a XHR request!
    if !@req.xhr?
      logger.error "PromoJudge#click: not a XHR/Ajax request"
      return not_found_page
    end

    logger.debug "PromoJudge#click: request params = #{@req.params.inspect}"
    logger.debug "PromoJudge#click: request session = #{@req.session.inspect}"
    logger.debug "PromoJudge#click: request cookies = #{@req.cookies.inspect}"

    event_machine do
      # get the current promotion from the DB
      get_current_promotion do |promotion|

        resp = case @req.params['usr_action'] 
               when 'play'     then 
                 action_played
               when 'judge'    then 
                 action_judged   
               when 'finish'   then 
                 action_finished
               else
                 logger.error "PromoJudge#click: illegal promo user action is #{@req.params['usr_action']}"
                 return not_found_page
               end

        logger.debug "PromoJudge#click: response = #{resp.inspect}"
        # signal to the web server, Thin, that it's HTTP request will be
        # handled asynchronously. It will not block
        env['async.callback'].call(click_response(resp))

        insert_promo_judge_click(resp)
        
      end
    end
    # returning this signals to the server we are sending an async
    # response
    Rack::Async::RESPONSE
  end

  private

  def symbolize(collection)
    collection.map do |entry|
      entry.inject({ }){ |memo,(k,v)| memo[k.to_sym] = v; memo}
    end
  end

  def click_response(response)
    [200, {"Content-Type" => "application/json"},[response[:to_client].to_json]]
  end

  def insert_promo_judge_click(resp, &blk)

    query = "INSERT INTO promo_data_judge_clicks (ip,media_key,click_action,created_at, updated_at,referrer, promotion_id) VALUES (\'#{resp[:data][:ip]}\', \'#{resp[:data][:media_key]}\',\'#{resp[:data][:click_action]}\', \'#{Time.now}\', \'#{Time.now}\', \'#{@req.referrer}\', \'#{resp[:data][:promotion_id]}\');"
    # logger.debug "PromoJudge#insert_promo_judge_click: SQL = #{query.inspect}"
        
    # Make the non-blocking/async query, returns a EM::Deferrable
    df = conn.execute(query)
    # success callback
    df.callback do |result|
      logger.debug "PromoJudge#click: Success Callback: DB results = #{Array(result).inspect}"
      if block_given?
        blk.call
      end
    end
        
    # error callback
    df.errback do |ex|
      logger.error "PromoJudge#click: Error Callback: Exception = #{ex.inspect}"        
      raise ex
    end
  end
  
  # Get the current Promotion for the DB
  def get_current_promotion(&blk)

    if @req.session['promotion_id']
      logger.debug "PromoJudge#get_current_promotion: Looking for promotion with id = #{@req.session['promotion_id']}"        
      df = conn.query("select * from promotions where id = \'#{@req.session['promotion_id']}\';")
    elsif @req.cookies['promo_code']
      logger.debug "PromoJudge#get_current_promotion: Looking for promotion with code = #{@req.cookies['promo_code']}"
      df = conn.query("select * from promotions where code = \'#{@req.cookies['promo_code']}\';")
    else
      logger.error "PromoJudge#get_current_promotion: no promotion in session or cookies"
      @current_promotion = nil
      return
    end

    df.callback do |promo_results|
      logger.debug "PromoJudge#get_current_promotion: Success Callback: DB results = #{Array(promo_results).inspect}"
      result = symbolize(promo_results).first

      # set the current_promotion
      @current_promotion = OpenStruct.new(result)
      logger.debug "PromoJudge#get_current_promotion: Success Callback: @current_promotion = #{@current_promotion.inspect}"      
      if block_given?
        blk.call
      end
    end 

    df.errback do |ex|
      # Some errors return a PG::Result ?
      if ex.is_a?(PG::Result)
        logger.error "PromoJudge#get_current_promotion: Error Callback: Result = #{Array(ex).inspect}"
      end
      logger.error "PromoJudge#get_current_promotion: Error Callback: Exception = #{ex.inspect}"
      @current_promotion = nil
      raise ex
    end
  end

  def promo_judge_click_url
    '/api/promo_judge/click'
  end
  
  def not_found_page
    [404,{"Content-Type" => "text/plain"},["Page Not Found"]]
  end

  def action_played
    logger.debug "PromoJudge#action_played"
    { :data => {
        :ip=> @req.ip,
        :promotion_id => current_promotion && current_promotion.id,
        :referrer => @req.referrer,
        :media_key => @req.params['media_key'],
        :click_action => 'play'
      },
      :to_client => {
        :action => 'replace',
        :content => '<a href="'+promo_judge_click_url+'" class="promo_click" rel="judge:'+ @req.params['media_key']+':like" style="text-decoration:none" >Love it!<img style="border:none" src="http://s1.ourstage.com/landing/cpc/png/thumbsUp_blu.png"></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="'+promo_judge_click_url+'" class="promo_click" style="text-decoration:none" rel="judge:'+ @req.params['media_key']+':dislike"><img style="border:none" src="http://s1.ourstage.com/landing/cpc/png/thumbsDown_blu.png">Hate it!</a>'
      }
    }      
  end
  
  def action_judged
    logger.debug "PromoJudge#action_judged"    
    if (@req.params[:mechanism] == 'link')
      { :data => {
          :ip=>request.remote_ip,
          :promotion_id => 9999,
          :referrer => session[:referrer],
          :media_key => @req.params['media_key'],
          :click_action => 'judge:'+ @req.params[:verdict]
        },
        :to_client => {
          :action => 'replace',
          :content => '<a href="'+promo_judge_click_url+'" class="promo_click" rel="finish:'+ @req.params['media_key']+'" >'+ @req.params[:finish_anchor_content]+'</a>'
        }
      }
    else
      { :data => {
          :ip=>request.remote_ip,
          :promotion_id => 9999,
          :referrer => session[:referrer],
          :media_key => @req.params['media_key'],
          :click_action => 'judge:'+ @req.params[:verdict]
        },
        :to_client => {
          :action => 'email_prompt',
          :prompt => @req.params[:finish_email_prompt],
          :key  => @req.params[:finish_email_key],
          :thank_you => @req.params[:finish_email_thank_you]
        }
      }
    end
  end
  
  
  
  def action_finished
    logger.debug "PromoJudge#action_finished"
    { :data => {
        :ip=>request.remote_ip,
        :promotion_id => 9999,
        :referrer => session[:referrer],
        :media_key => @req.params['media_key'],
        :click_action => 'register'
      },
      :to_client => {
        :action => 'redirect',
        :new_loc => @req.params[:redir_url]
      }
    }
  end 
  
  # make sure EventMachine is running (if we're on thin it'll be up
  # and running, but this isn't the case on other servers).
  def event_machine(&block)
    if EM.reactor_running?
      logger.debug "PromoJudge#event_machine: EventMachine Reactor is running"    
      block.call
    else
      logger.debug "PromoJudge#event_machine: EventMachine Reactor is NOT running"    
      Thread.new {EM.run}
      EM.next_tick(block)
    end
  end

end
