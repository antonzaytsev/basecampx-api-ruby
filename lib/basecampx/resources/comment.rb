module Basecampx
  class Comment < Basecampx::Resource

    attr_accessor :id, :content, :created_at, :updated_at, :attachments, :creator, :topic_url

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