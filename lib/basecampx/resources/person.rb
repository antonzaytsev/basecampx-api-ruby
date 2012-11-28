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
      update_details self.url
    end

    def last_events since=1.day.ago
      Event.parse Basecampx.request "people/#{self.id}/events.json?since=#{since.to_time.iso8601}"
    end

private

    def update_details url=nil
      self.update_attributes Basecampx.request(url || "people/#{self.id}.json")
      self
    end

  end
end