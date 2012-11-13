module Basecampx
  class Project < Basecampx::Resource

    attr_accessor :id, :name, :description, :archived, :created_at, :updated_at, :starred, :url

    def self.all
      Project.parse Basecampx.request "projects.json"
    end

    def self.find project_id
      Project.new Basecampx.request "projects/#{project_id}.json"
    end

    def initialize args
      self.update_details args
    end

    def update_details args
      args.each do |key, value|
        self.send(key.to_s+'=', value) if self.respond_to?((key.to_s+'=').to_s)
      end
    end

    def self.parse json
      output = []

      json.each do |user|
        output << self.new(user)
      end

      output
    end

    # GET /projects/1/todos/1.json will return the specified todo.
    def todo todo_id
      Todo.new Basecampx.request "projects/#{self.id}/todos/#{todo_id}.json"
    end

    # GET /projects/1/todolists.json shows active todolists for this project sorted by position.
    # GET /projects/1/todolists/completed.json shows completed todolists for this project.
    def todo_lists completed=false
      TodoList.parse Basecampx.request "projects/#{self.id}/todolists#{completed ? '/completed' : ''}.json"
    end

    # GET /projects/1/todolists/1.json will return the specified todolist including the todos.
    def todo_list todo_list_id
      TodoList.new Basecampx.request "projects/#{self.id}/todolists/#{todo_list_id}.json"
    end

  end
end