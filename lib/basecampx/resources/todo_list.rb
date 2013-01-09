module Basecampx
  class TodoList < Basecampx::Resource

    attr_accessor :id, :name, :description, :created_at, :updated_at, :completed, :position, :remaining_count,
                  :completed_count, :url, :bucket, :todos

    attr_reader :todos

    has_one :bucket, :project
    has_one :creator, :person
    has_many :assigned_todos, :todo

    alias_method :project, :bucket

    # shows active todolists for all projects
    # GET /todolists.json
    def self.all
      self.parse Basecampx.request "todolists.json"
    end

    # shows completed todolists for all projects
    # GET /todolists/completed.json
    def self.completed
      self.parse Basecampx.request "todolists/completed.json"
    end

    def self.find project_id, todolist_id
      self.new Basecampx.request "projects/#{project_id}/todolists/#{todolist_id}.json"
    end

    def self.find_by_id todolist_id
      self.all.each do |tl|
        if tl.id == todolist_id
          return tl
        end
      end
      false
    end

    def todos= todos_obj
      @todos = {
        :completed => Todo.parse(todos_obj['completed']),
        :remaining => Todo.parse(todos_obj['remaining'])
      }
    end

    def more_info!
      if self.url
        self.update_attributes Basecampx.request self.url
      else
        false
      end
    end

  end
end