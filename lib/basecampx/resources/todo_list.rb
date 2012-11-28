module Basecampx
  class TodoList < Basecampx::Resource

    attr_accessor :id, :name, :description, :created_at, :updated_at, :completed, :position, :remaining_count,
                  :completed_count, :url, :bucket

    has_one :creator, :person
    has_many :assigned_todos, :todo

    # GET /todolists.json shows active todolists for all projects.
    def self.all
      self.parse Basecampx.request "todolists.json"
    end

    # GET /todolists/completed.json shows completed todolists for all projects.
    def self.completed
      self.parse Basecampx.request "todolists/completed.json"
    end

    def self.find project_id, todolist_id
      self.new Basecampx.request "projects/#{project_id}/todolists/#{todolist_id}.json"
    end

    def todos
      assigned_todos
    end

  end
end