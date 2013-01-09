module Basecampx
  class << self
    def use! project=:default
      @project = project
      details = YAML.load(File.read(File.join(Rails.root, 'config', 'basecampx.yaml')))
      @connect_details = details[project.to_s].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      self
    end

    def use_custom! username, password, project_id, api_version=1
      @project = :custom
      @connect_details = {
        :provider => 'http',
        :project_id => project_id,
        :username => username,
        :password => password,
        :api_version => api_version
      }
      self
    end

    def use_oauth2! user_agent, token, project_id, api_version=1
      @project = :oauth2
      @connect_details = {
        :provider => 'oauth2',
        :user_agent => user_agent,
        :access_token => token,
        :project_id => project_id,
        :api_version => api_version
      }
    end

    def connect_details
      @connect_details
    end

    def account_endpoint
      if @project.nil?
        self.use!
      end

      "https://basecamp.com/#{@connect_details[:project_id]}/api/v#{@connect_details[:api_version] || 1}"
    end

    def request url, *args
      options = args.extract_options!
      method = options[:method] ? options[:method].to_sym : :get
      method = method.in?([:get,:post,:put,:delete]) ? method : :get
      options.delete :method
      self.send method, url, options
    end

    def get url, *args
      options = args.extract_options!
      ask(:get, url, options)
    end

    def put url, *args
      options = args.extract_options!
      options[:headers] ||= {}
      options[:headers]['Content-Type'] = 'application/json'
      if options[:body]
        options[:body] = options[:body].to_json
      end
      ask(:put, url, options)
    end

    def post url, *args
      options = args.extract_options!
      options[:headers] ||= {}
      options[:headers]['Content-Type'] = 'application/json'
      if options[:body]
        options[:body] = options[:body].to_json
      end
      ask(:post, url, options)
    end

    #def delete url, query={}
    #  request url, :query => query, :method => :delete
    #end

    #def logger
    #  if defined?('Rails') && Rails.logger
    #    Rails.logger
    #  end
    #end

  private

    def ask method, url, options
      url = url.sub(/https\:\/\/basecamp\.com\/\d*\/api\/v1/, '').sub(/^\//, '')
      url = "#{account_endpoint}/#{url}"

      credentials = request_credentials
      credentials[:body] = options[:body]

      if options[:headers]
        credentials[:headers].merge!(options[:headers])
      end

      if defined?('Rails') && Rails.env.development?
        p "#{method.upcase} Request: #{url}"
        credentials[:debug_output] = STDOUT
      end
      resp = HTTParty.send(method, url, credentials)

      handle resp
    end

    def handle response
      if response.code == 200
        JSON.parse(response.body)
      elsif response.code == 201
        JSON.parse(response.body)
      elsif response.code == 204
        true
      elsif response.code == 404
        raise Exception, "API can't find specified URL #{response.request.path}"
      else
        raise Exception, response
      end
    end

    def request_credentials
      if @project == :oauth2 && @connect_details[:access_token]
        {
          :headers => {
            "User-Agent" => @connect_details[:user_agent] || :web_server,
            "Authorization" => 'Bearer ' + @connect_details[:access_token]
          }
        }
      else
        {
          :basic_auth => {
            :username => @connect_details[:username],
            :password => @connect_details[:password]
          },
          :headers => {
            "User-Agent" => @connect_details[:username]
          }
        }
      end
    end

  end
end