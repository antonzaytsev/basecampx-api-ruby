module Basecampx
  class << self
    def use! project=:default
      @project = project
      @details = YAML.load(File.read(File.join(Rails.root, 'config', 'basecampx.yaml')))
      @connect_details = @details[project.to_s]
      @account_endpoint = "https://basecamp.com/#{@connect_details['project_id']}/api/v#{@connect_details['api_version'] || 1}"

      test_connection
    end

    def test_connection
      true
    end

    def use_custom! username, password, project_id

    end

    #def initialize username='', password='', account_endpoint='https://basecamp.com/1908192/api/v1', app='Syllabuster Sync (http://sylly.co)'
    #  @username = username
    #  @password = password
    #  @account_endpoint = account_endpoint
    #  @app = app
    #end

    def params
      account_endpoint

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
      if !@account_endpoint
        self.use!
      end

      @account_endpoint
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

    def todolists project_id
      self.request "#{account_endpoint}/projects/#{project_id}/todolists.json"
    end

    def todolist project_id, todolist_id
      response = HTTParty.get "#{@account_endpoint}/projects/#{project_id}/todolists/#{todolist_id}.json", params
      handle response
    end

    def todos project_id, todo_id
      self.request "#{@account_endpoint}/projects/#{project_id}/todos/#{todo_id}.json"
    end

    def people
      json = self.request "#{account_endpoint}/people.json"
      self::Person.parse json
    end

    def person account_id
      json = self.request "#{@account_endpoint}/people/#{account_id}.json"
      self::Person.new json
    end

    def request url
      handle HTTParty.get url, params
    end
  end
end