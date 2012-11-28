module Basecampx
  class Comment < Basecampx::Resource

    attr_accessor :id, :content, :created_at, :updated_at, :topic_url

    has_one :creator, :person
    has_many :attachments, :attachment

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

  end
end