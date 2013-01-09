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

    def self.first
      self.all.first
    end

    # For development?
    def self.random
      self.all.sample
    end

    # GET /people/1/assigned_todos.json
    def todo_lists
      TodoList.parse Basecampx.request "people/#{self.id}/assigned_todos.json"
    end

    def reload!
      self.update_attributes Basecampx.request(url || "people/#{self.id}.json")
    end

    def last_events since=1.day.ago
      Event.parse Basecampx.request "people/#{self.id}/events.json?since=#{since.to_time.iso8601}"
    end

    # GET /projects/1/topics.json
    def topics
      Topic.parse Basecampx.request "projects/#{self.id}/topics.json"
    end

  end
end