module Basecampx
  class Todo < Basecampx::Resource

    attr_accessor :id, :todolist_id, :position, :content, :completed, :due_at, :created_at, :updated_at,
                  :comments_count

    has_many :comments, :comment
    has_many :subscribers, :person
    has_one :creator, :person
    belongs_to :assignee, :person

    # https://github.com/37signals/bcx-api/blob/master/sections/todos.md#update-todo
    # PUT /projects/1/todos/1.json
    # Will update the todo from the parameters passed.
    # The completed field can be set to either true or false to check or uncheck the todo.
    self.update_url = lambda { |el| "/projects/#{el.project.id}/todos/#{el.id}.json" }

    # https://github.com/37signals/bcx-api/blob/master/sections/todos.md#create-todo
    # POST /projects/1/todolists/1/todos.json
    # will add a new todo to the specified todolist from the parameters passed.
    # The due_at parameter should be in ISO 8601 format (like "2012-03-27T16:00:00-05:00").
    # The assignee parameters need a type field with the Person specified.
    # The id is then the id of the person who was assigned.
    self.create_url = lambda { |el| "/projects/#{el.project.id}/todolists/#{el.todolist_id}/todos.json" }

    # https://github.com/37signals/bcx-api/blob/master/sections/todos.md#delete-todo
    # DELETE /projects/1/todos/1.json
    # will delete todo
    self.delete_url = lambda { |el| "/projects/#{el.project.id}/todos/#{el.id}.json" }

    def accessors
      [:todolist_id, :position, :content, :completed, :due_at, :assignee]
    end

    def self.first
      Project.all.last.todos.first
    end

    def self.random
      projects = Project.all
      projects.each do |project|
        todo = project.todos.first
        if todo
          return todo
        end
      end
    end

    #def self.find todo_id
    #  self.new self.get_one todo_id.project.id, todo_id
    #end

    # GET /projects/1/todos/1.json will return the specified todo.
    def self.find_by_project_id project_id, todo_id
      self.new self.get_one project_id, todo_id
    end

    def reload!
      self.update_attributes self.class.get_one(self.project.id, self.id)
    end

    def attachments
      if self.comments_count > 0
        unless self.comments
          self.reload!
        end

        attachs = []
        self.comments.each do |comment|
          attachs += comment.attachments if comment.attachments
        end
        attachs
      else
        []
      end
    end

    def todolist
      if !@_tl || @_tl.id != self.todolist_id
        @_tl = TodoList.find_by_id self.todolist_id
      end
      @_tl
    end

    def project
      self.todolist.project
    end

private

    def self.get_one project_id, todo_id
      Basecampx.request "projects/#{project_id}/todos/#{todo_id}.json"
    end

  end
end