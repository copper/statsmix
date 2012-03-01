require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'
class StatsMix
  
  BASE_URI = 'https://statsmix.com/api/v2/'
  
  GEM_VERSION = File.exist?('../VERSION') ? File.read('../VERSION') : ""

  # Track an event
  # 
  # Required: name of metric
  # Optional: value, options {:generated_at}
  # Returns: Net::HTTP object
  def self.track(name, value = nil, options = {})
    if options.respond_to?('with_indifferent_access')
      options = options.with_indifferent_access
    end
    self.connect('track')
    @request_uri = @url.path + '.' + @format
    @request = Net::HTTP::Get.new(@request_uri)
    @params[:name] = name
    if @test_metric_name
      @params[:name] = @test_metric_name
    end
    @params[:value] = Float(value) unless value.nil?
    @params.merge!(options)
    self.check_meta
    return do_request
  end
  # Stats
  
  # List stats (index)
  # 
  # Required: metric_id
  # Optional: limit, {:startdate => nil, :end_date => nil}
  # Use start_date and end_date as has keys in the third param to scope the date range of stats based on the generated_at timestamp of a stat
  # Returns: Net::HTTP object
  def self.list_stats(metric_id, limit = nil, options = {})
    if options.respond_to?('with_indifferent_access')
      options = options.with_indifferent_access
    end
    self.connect('stats')
    @request_uri = @url.path + '.' + @format
    @request = Net::HTTP::Get.new(@request_uri)
    
    @params[:metric_id] = metric_id
    @params.merge!(options)
    if @params[:start_date] && @params[:start_date].is_a?(ActiveSupport::TimeWithZone)
      @params[:start_date] = @params[:start_date].utc.strftime('%Y-%m-%d %H:%M:%S')
    end
    if @params[:end_date] && @params[:end_date].is_a?(ActiveSupport::TimeWithZone)
      @params[:end_date] = @params[:end_date].utc.strftime('%Y-%m-%d %H:%M:%S')
    end
    return do_request
  end
  
  # Get stat
  # 
  # Required: stat_id
  # Optional: none
  # Returns: Net::HTTP object
  def self.get_stat(stat_id)
    connect('stats')
    @request_uri = @url.path + '/' + stat_id.to_s + '.' + @format
    @request = Net::HTTP::Get.new(@request_uri)
    return do_request
  end
  
  # Create stat
  # 
  # Required: metric_id
  # Optional: value, params[:generated_at, :meta]
  # Returns: Net::HTTP object
  def self.create_stat(metric_id, value = nil, params = {})
    if params.respond_to?('with_indifferent_access')
      params = params.with_indifferent_access
    end
    connect('stats')
    @request_uri = @url.path + '.' + @format
    @request = Net::HTTP::Post.new(@request_uri)
    @params[:metric_id] = metric_id
    @params[:value] = value if value
    @params.merge!(params)
    self.check_meta
    return do_request
  end
  
  # Update stat
  # 
  # Required: stat_id
  # Optional: value, params[:generated_at, :meta]
  # Returns: Net::HTTP object
  def self.update_stat(stat_id, value = nil, params = {})  
    if params.respond_to?('with_indifferent_access')
      params = params.with_indifferent_access
    end
    connect('stats')
    @request_uri = @url.path + '/' + stat_id.to_s + '.' + @format
    @request = Net::HTTP::Put.new(@request_uri)
    @params[:value] = value if value
    @params.merge!(params)
    self.check_meta
    return do_request
  end
  
  # Delete stat
  # 
  # Required: stat_id
  # Optional: none
  # Returns: Net::HTTP object
  def self.delete_stat(stat_id)    
    connect('stats')
    @request_uri = @url.path + '/' + stat_id.to_s + '.' + @format
    @request = Net::HTTP::Delete.new(@request_uri)
    return do_request
  end
  
  # Metrics
  
  # List metrics
  # 
  # Required: none
  # Optional: profile_id, limit
  # Returns: Net::HTTP object
  def self.list_metrics(profile_id = nil, limit = nil)
    connect('metrics')
    @request_uri = @url.path + '.' + @format
    @request = Net::HTTP::Get.new(@request_uri)

    @params[:profile_id] = profile_id if profile_id  != nil
    @params[:limit] = limit if limit != nil
    
    return do_request
  end
  
  # Get metric
  # 
  # Required: metric_id
  # Optional: none
  # Returns: Net::HTTP object
  def self.get_metric(metric_id)
    connect('metrics')
    @request_uri = @url.path + '/' + metric_id.to_s + '.' + @format
    @request = Net::HTTP::Get.new(@request_uri)
    return do_request
  end
  
  # Create metric
  # 
  # Required: name
  # Optional: params[:profile_id, :sharing, :include_in_email]
  # Returns: Net::HTTP object
  def self.create_metric(name, params = {})
    if params.respond_to?('with_indifferent_access')
      params = params.with_indifferent_access
    end
    connect('metrics')
    @params.merge!(params)
    @params[:name] = name
    @request_uri = @url.path + '.' + @format
    @request = Net::HTTP::Post.new(@request_uri)
    return do_request
  end
  
  # Update metric
  # 
  # Required: metric_id
  # Optional: params[:profile_id, :sharing, :include_in_email]
  # Returns: Net::HTTP object
  def self.update_metric(metric_id, params = {})
    if params.respond_to?('with_indifferent_access')
      params = params.with_indifferent_access
    end
    connect('metrics')
    @params = [] if @params.nil?
    @params.merge!(params)
    @request_uri = @url.path + '/' + metric_id.to_s + '.' + @format
    @request = Net::HTTP::Put.new(@request_uri)

    return do_request
  end
  
  # Delete metric
  # 
  # Required: metric_id
  # Optional: none
  # Returns: Net::HTTP object
  def self.delete_metric(metric_id)    
    connect('metrics')
    @request_uri = @url.path + '/' + metric_id.to_s + '.' + @format
    @request = Net::HTTP::Delete.new(@request_uri)
    return do_request
  end
  
  # partner api methods
  # see http://www.statsmix.com/developers/partner_api
  
  # list users
  # 
  # Optional: none
  # Returns: Net::HTTP object
  def self.list_users
    connect('partners/users')
    @request_uri = @url.path
    @request = Net::HTTP::Get.new(@request_uri)
    return do_request
  end
  
  # Get user
  # 
  # Required: id_or_api_key - id or api key of the user to get
  # Optional: none
  # Returns: Net::HTTP object
  def self.get_user(id_or_api_key)
    connect('partners/users')
    @request_uri = @url.path + '/' + id_or_api_key.to_s + '.' + @format
    @request = Net::HTTP::Get.new(@request_uri)
    return do_request
  end
  
  # Create user
  # 
  # Required: {:email => 'user@example.com'} - if the email already exists in our system, we will return the existing user
  # Optional: :email,:name,:plan,:company,:url, :metrics[]
  # Returns: Net::HTTP object
  def self.create_user(params = {})
    connect('partners/users')
    @request_uri = @url.path + '.' + @format
    @request = Net::HTTP::Post.new(@request_uri)
    @params.merge!(params)
    result = do_request
    unless self.error
      @user_api_key = result.scan(/<api_key>[0-9a-zA-Z]*<\/api_key>/)[0].gsub(/<\/?api_key>/,'')
    end
    return result
  end
  
  # Update user
  # 
  # Required: id_or_api_key - id or api key of the user to get
  # Optional: params with keys :email,:name,:plan,:company,:url
  # Returns: Net::HTTP object
  def self.update_user(id_or_api_key, params = {})  
    connect('partners/users')
    @request_uri = @url.path + '/' + id_or_api_key.to_s + '.' + @format
    @request = Net::HTTP::Put.new(@request_uri)
    @params.merge!(params)
    result = do_request
    unless self.error
      @user_api_key = result.scan(/<api_key>[0-9a-zA-Z]*<\/api_key>/)[0].gsub(/<\/?api_key>/,'')
    end
    return result
  end
  
  # Delete user
  # 
  # Required: id_or_api_key - id or api key of the user to get
  # Optional: none
  # Returns: Net::HTTP object
  def self.delete_user(id_or_api_key)    
    connect('partners/users')
    @request_uri = @url.path + '/' + id_or_api_key.to_s + '.' + @format
    @request = Net::HTTP::Delete.new(@request_uri)
    result = do_request
    unless self.error
      @user_api_key = result.scan(/<api_key>[0-9a-zA-Z]*<\/api_key>/)[0].gsub(/<\/?api_key>/,'')
    end
    return result
  end
  
  # Returns: Net::HTTP object
  def self.response
    @response
  end
  
  # Returns: string or boolean false
  def self.error
    @error
  end
  
  # Returns: hash
  def self.params
    @params
  end
  
  def self.api_key=(string)
    @api_key = string
  end
  
  # Returns: string
  def self.api_key
    @api_key
  end
  
  def self.ignore=(boolean)
    @ignore = boolean ? true : false
  end
  
  #Returns: boolean
  def self.ignore
    @ignore
  end
  
  #Return: string
  def self.user_api_key
    @user_api_key
  end
  
  def self.test_metric_name=(name)
    @test_metric_name = name
  end
  
  #Returns: string or nil
  def self.test_metric_name
    @test_metric_name
  end
  
  # Returns: string
  def self.api_key
    @api_key
  end
  
  def self.api_from_env
    return nil if ENV['STATSMIX_URL'].nil?
    url = ENV['STATSMIX_URL']
    pieces = url.gsub('http://','').gsub('https://','').split('/')
    @api_key = pieces[2]
  end
  
  def self.format=(string)
    string.downcase!
    if string != 'json' && string != 'xml'
      raise "format MUST be either xml or json"
    end
    @format = string
  end
  
  # Returns: string
  def self.format
    @format
  end
  
  # Returns: string
  def self.request_uri
    @request_uri
  end
  private
  
  def self.setup(api_key = nil)
    return if @initiliazed
    if !api_key.nil?
      @api_key = api_key
    end
    @format = 'xml' if @format.nil?
    @ignore = false if @ignore.nil?
    @user_agent = "StatsMix Ruby Gem " + GEM_VERSION
    @initiliazed = true
    @error = false
  end
  
  def self.connect(resource)
    self.setup
    
    if @api_key.nil?
      raise "API key not set. You must set it first with StatsMix.api_key = [your api key]"
    end
    
    # Resources available: stats, metrics, TODO: profiles
    @url = URI.parse(BASE_URI + resource)
    @connection = Net::HTTP.new(@url.host, @url.port)
    @connection.use_ssl = (@url.scheme == 'https')
    
    @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    @request = Hash.new
    @request["User-Agent"] = @user_agent
    @params = Hash.new
    if @params.respond_to?('with_indifferent_access')
      @params = @params.with_indifferent_access
    end
    @params[:api_key] = @api_key
  end
  
  def self.do_request
    @error = false
    return if @ignore
    #had to add code to support properly encoding array values.  See http://blog.assimov.net/post/653645115/post-put-arrays-with-ruby-net-http-set-form-data
    self.set_form_data(@params)
    @response = @connection.request(@request)
    if @response.is_a?(Net::HTTPClientError)
      if 'xml' == @format
        begin
          @error = @response.body.match('<error>(.)+</error>')[0].gsub('<error>','').gsub('</error>','')
        rescue
          @error = 'Unable to parse error message. Check StatsMix.response for more information'
        end
      else
        @error = JSON.parse(@response.body)['errors']['error']
      end
    end
    @response.body
  end
  #based on http://blog.assimov.net/post/653645115/post-put-arrays-with-ruby-net-http-set-form-data
  def self.set_form_data(params, sep = '&')
    @request.body = params.map {|k,v|
      if v.instance_of?(Array)
        v.map {|e| "#{self.urlencode(k.to_s)}[]=#{urlencode(e.to_s)}"}.join(sep)
      else
        "#{self.urlencode(k.to_s)}=#{self.urlencode(v.to_s)}"
      end
    }.join(sep)
    @request.content_type = 'application/x-www-form-urlencoded'
  end

  def self.urlencode(str)
    URI.encode(str, /[^a-zA-Z0-9_\{\}:, \"\.\-]/n)
  end
  
  def self.check_meta
    if @params[:meta] && !@params[:meta].is_a?(String) && !@params[:meta].is_a?(Hash)
      raise "Invalid data . :meta should be a hash or a json-encoded string. You passed an object of type: #{@params[:meta].type}"
    end
    if @params[:meta].nil? && @params['meta'] 
      @params[:meta] = @params['meta']
      @params.delete('meta')
    end
    if @params[:meta] && !@params[:meta].is_a?(String)
      if @params[:meta].respond_to?('to_json')
        @params[:meta] = @params[:meta].to_json
      end
    end
  end
end

StatsMix.api_from_env