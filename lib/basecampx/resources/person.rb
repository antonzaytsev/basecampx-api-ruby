module Basecampx
  class Person

    attr_accessor :id, :name, :email_address, :admin, :created_at, :avatar_url, :url, :identity_id,
                  :events, :assigned_todos, :todo_list

    def self.parse json
      output = []

      json.each do |user|
        output << self.new(user)
      end

      output
    end

    def initialize args
      self.update_details args
    end

    def update_details args
      args.each do |key, value|
        self.send(key.to_s+'=', value) if self.respond_to?((key.to_s+'=').to_s)
      end
    end

    def todos
      if self.assigned_todos.nil?
        self.details
      end

      self.todo_list = Basecampx.request self.assigned_todos['url']
    end

    def details
      resp = Basecampx.request self.url
      update_details resp
      self
    end

  end
end