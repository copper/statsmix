require 'net/http'

class StatsMix
  
  BASE_URI = 'http://www.statsmix.com/api/v2/'
  # BASE_URI = 'http://localhost:3000/api/v2/'
  
  GEM_VERSION = File.exist?('../VERSION') ? File.read('../VERSION') : ""
  
  def initialize(api_key, format = 'xml')
    @api_key = api_key
    @format = format
    @user_agent = "StatsMix Ruby Gem " + GEM_VERSION
  end
  
  def connect(resource)
    # Resources available: stats, metrics, TODO: profiles
    @url = URI.parse(BASE_URI + resource)
    @connection = Net::HTTP.new(@url.host, @url.port)
    
  end
  
  # Stats
  
  # List stats (index)
  # 
  # Required: metric_id
  # Optional: limit
  def list_stats(metric_id, limit = nil)
    connect('stats')
    request = Net::HTTP::Get.new(@url.path + '.' + @format)
    request["User-Agent"] = @user_agent
    
    form_hash = Hash.new
    form_hash["api_key"] = @api_key
    form_hash["metric_id"] = metric_id
    if limit != nil
      form_hash["limit"] = limit
    end
    
    request.set_form_data(form_hash)
    
    response = @connection.request(request)
    return response.body
  end
  
  # Get stat
  # 
  # Required: stat_id
  # Optional: none
  def get_stat(stat_id)
    connect('stats')
    request = Net::HTTP::Get.new(@url.path + '/' + stat_id.to_s + '.' + @format)
    request["User-Agent"] = @user_agent
    
    request.set_form_data({"api_key" => @api_key})
    
    response = @connection.request(request)
    return response.body
  end
  
  # Create stat
  # 
  # Required: metric_id
  # Optional: value, generated_at, meta
  def create_stat(metric_id, value = 1, generated_at = Time.now, meta = nil)
    connect('stats')
    request = Net::HTTP::Post.new(@url.path + '.' + @format)
    request["User-Agent"] = @user_agent

    form_hash = Hash.new
    form_hash["api_key"] = @api_key
    form_hash["value"] = value
    form_hash["metric_id"] = metric_id
    form_hash["generated_at"] = generated_at
    if meta != nil
      form_hash["meta"] = meta
    end
    
    request.set_form_data(form_hash)
    
    response = @connection.request(request)
    return response.body
  end
  
  # Update stat
  # 
  # Required: stat_id
  # Optional: value, generated_at, meta
  def update_stat(stat_id, value = nil, generated_at = nil, meta = nil)  
    connect('stats')
    request = Net::HTTP::Put.new(@url.path + '/' + stat_id.to_s + '.' + @format)
    request["User-Agent"] = @user_agent

    form_hash = Hash.new
    form_hash["api_key"] = @api_key
    if value != nil
      form_hash["value"] = value
    end
    if generated_at != nil
      form_hash["generated_at"] = generated_at
    end
    if meta != nil
      form_hash["meta"] = meta
    end
    
    request.set_form_data(form_hash)

    response = @connection.request(request)
    return response.body
  end
  
  # Delete stat
  # 
  # Required: stat_id
  # Optional: none
  def delete_stat(stat_id)    
    connect('stats')
    request = Net::HTTP::Delete.new(@url.path + '/' + stat_id.to_s + '.' + @format)
    request["User-Agent"] = @user_agent
    
    request.set_form_data({"api_key" => @api_key})
    
    response = @connection.request(request)
    return response.body
  end
  
  # Metrics
  
  # List metrics
  # 
  # Required: none
  # Optional: profile_id, limit
  def list_metrics(profile_id = nil, limit = nil)
    connect('metrics')
    request = Net::HTTP::Get.new(@url.path + '.' + @format)
    request["User-Agent"] = @user_agent
    
    form_hash = Hash.new
    form_hash["api_key"] = @api_key
    if profile_id != nil
      form_hash["profile_id"] = profile_id
    end
    if limit != nil
      form_hash["limit"] = limit
    end
    
    request.set_form_data(form_hash)
    
    response = @connection.request(request)
    return response.body
  end
  
  # Get metric
  # 
  # Required: metric_id
  # Optional: none
  def get_metric(metric_id)
    connect('metrics')
    request = Net::HTTP::Get.new(@url.path + '/' + metric_id.to_s + '.' + @format)
    request["User-Agent"] = @user_agent
    
    request.set_form_data({"api_key" => @api_key})
    
    response = @connection.request(request)
    return response.body
  end
  
  # Create metric
  # 
  # Required: name
  # Optional: profile_id, generated_at
  def create_metric(name, profile_id = nil)
    connect('metrics')
    request = Net::HTTP::Post.new(@url.path + '.' + @format)
    request["User-Agent"] = @user_agent

    form_hash = Hash.new
    form_hash["api_key"] = @api_key
    form_hash["name"] = name
    if profile_id != nil
      form_hash["profile_id"] = profile_id
    end
    
    request.set_form_data(form_hash)
    
    response = @connection.request(request)
    return response.body
  end
  
  # Update metric
  # 
  # Required: metric_id
  # Optional: name, sharing, include_in_email
  def update_metric(metric_id, name = nil, sharing = nil, include_in_email = nil)  
    connect('metrics')
    request = Net::HTTP::Put.new(@url.path + '/' + metric_id.to_s + '.' + @format)
    request["User-Agent"] = @user_agent

    form_hash = Hash.new
    form_hash["api_key"] = @api_key
    if name != nil
      form_hash["name"] = name
    end
    if sharing != nil
      form_hash["sharing"] = sharing
    end
    if include_in_email != nil
      form_hash["include_in_email"] = include_in_email
    end
    
    request.set_form_data(form_hash)

    response = @connection.request(request)
    return response.body
  end
  
  # Delete metric
  # 
  # Required: metric_id
  # Optional: none
  def delete_metric(metric_id)    
    connect('metrics')
    request = Net::HTTP::Delete.new(@url.path + '/' + metric_id.to_s + '.' + @format)
    request["User-Agent"] = @user_agent
    
    request.set_form_data({"api_key" => @api_key})
    
    response = @connection.request(request)
    return response.body
  end
end