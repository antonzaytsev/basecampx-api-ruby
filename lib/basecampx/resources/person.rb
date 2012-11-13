module Basecampx
  class Person < Basecampx::Resource

    attr_accessor :id, :name, :email_address, :admin, :created_at, :avatar_url, :url, :identity_id,
                  :events, :assigned_todos, :todo_list

    def self.find person_id
      self.new Basecampx.request "people/#{person_id}.json"
    end

    def self.all
      self.parse Basecampx.request "people.json"
    end

    # GET /people/1/assigned_todos.json
    def todos
      TodoList.parse Basecampx.request "people/#{self.id}/assigned_todos.json"
    end

    def details
      resp = Basecampx.request self.url
      update_details resp
      self
    end

  end
end