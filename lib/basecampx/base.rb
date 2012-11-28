module Basecampx
  class << self
    def use! project=:default
      @project = project
      details = YAML.load(File.read(File.join(Rails.root, 'config', 'basecampx.yaml')))
      @connect_details = details[project.to_s]
    end

    def use_custom! username, password, project_id, api_version=1
      @project = :custom
      @connect_details = {
        'project_id' => project_id,
        'username' => username,
        'password' => password,
        'api_version' => api_version
      }
    end



    def account_endpoint
      if @project.nil?
        self.use!
      end

      "https://basecamp.com/#{@connect_details['project_id']}/api/v#{@connect_details['api_version'] || 1}"
    end

    def handle response
      if response.code == 200
        JSON.parse(response.body)
      elsif response.code == 204
        true
      elsif response.code == 404
        raise Exception, "API can't find specified URL #{response.request.path}"
      else
        raise Exception, response
      end
    end

    def request url, params={}
      url = url.sub /https\:\/\/basecamp\.com\/\d*\/api\/v1/, ''

      handle HTTParty.send(params[:method] || :get, "#{account_endpoint}/#{url.sub(/^\//, '')}", request_credentials )
    end

    def get url, params={}
      params[:method] = :get
      request url, params
    end

    def put url, params={}
      params[:method] = :put
      request url, params
    end

    def post url, params={}
      params[:method] = :post
      request url, params
    end

    def delete url, params={}
      params[:method] = :delete
      request url, params
    end

    private

    def request_credentials
      {
        :basic_auth => {
          :username => @connect_details['username'],
          :password => @connect_details['password']
        },
        :headers => {
          "User-Agent" => @connect_details['username']
        }
      }
    end

  end
end