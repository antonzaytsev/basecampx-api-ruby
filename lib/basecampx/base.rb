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

    def params
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

    def account_endpoint
      if @project.nil?
        self.use!
      end

      "https://basecamp.com/#{@connect_details['project_id']}/api/v#{@connect_details['api_version'] || 1}"
    end

    def handle response
      if response.code == 200
        JSON.parse(response.body)
      else
        raise Exception, response
      end
    end

    def projects
      self.request "#{account_endpoint}/projects.json"
    end

    def project id
      response = HTTParty.get "#{@account_endpoint}/projects/#{id}.json", params
      handle response
    end

    def request url
      handle HTTParty.get "#{account_endpoint}/#{url.sub(/^\//, '')}", params
    end
  end
end