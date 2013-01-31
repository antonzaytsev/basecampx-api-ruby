module Basecampx
  class Project < Basecampx::Resource

    attr_accessor :id, :name, :description, :archived, :created_at, :updated_at, :starred, :url

    def self.all
      self.parse Basecampx.request "projects.json"
    end

    def self.first
      self.all.first
    end

    def self.find project_id
      self.new self.get_one project_id
    end

    # For development?
    def self.random
      self.all.sample
    end

    def todo todo_id
      Todo.find self.id, todo_id
    end

    # Warning! Very slow
    def todos
      todos = []
      self.todo_lists.each do |tl|
        tl.more_info!
        todos += tl.todos[:remaining] if tl.todos[:remaining] && tl.todos[:remaining].size >0
      end
      todos
    end

    # GET /projects/1/todolists.json shows active todolists for this project sorted by position.
    # GET /projects/1/todolists/completed.json shows completed todolists for this project.
    # type can be 'active', 'completed', 'all'
    # by default we use 'active'
    def todo_lists type=:active
      type = type.to_s
      if type == 'active'
        TodoList.parse Basecampx.request "projects/#{self.id}/todolists.json"
      elsif type == 'completed'
        TodoList.parse Basecampx.request "projects/#{self.id}/todolists/completed.json"
      else
        active = TodoList.parse Basecampx.request "projects/#{self.id}/todolists.json"
        completed = TodoList.parse Basecampx.request "projects/#{self.id}/todolists/completed.json"
        active.concat completed
      end
    end

    # GET /projects/1/todolists/1.json will return the specified todolist including the todos.
    def todo_list todo_list_id
      TodoList.new Basecampx.request "projects/#{self.id}/todolists/#{todo_list_id}.json"
    end

    def events since=1.day.ago
      Event.parse Basecampx.request "/projects/#{self.id}/events.json?since=#{since.to_time.iso8601}"
    end

    # GET /projects/1/attachments.json
    def attachments
      Attachment.parse Basecampx.request "projects/#{self.id}/attachments.json"
    end

    # GET /projects/1/documents.json
    def documents
      Document.parse Basecampx.request "projects/#{self.id}/documents.json"
    end

    # GET /projects/1/documents/1.json
    def document document_id
      Document.new Basecampx.request "projects/#{self.id}/documents/#{document_id}.json"
    end

    # GET /projects/1/accesses.json
    def accesses
      Person.parse Basecampx.request "projects/#{self.id}/accesses.json"
    end

    # POST /projects/1/accesses.json
    #def grant_access ids, emails
    #  Basecampx.post "projects/#{self.id}/accesses.json"
    #end

    # DELETE /projects/1/accesses/1.json
    def revoke_access person
      if person.class.name == "Basecampx::Person"
        person_id = person.id
      elsif person.integer?
        person_id = person
      end

      Basecampx.delete "projects/#{self.id}/accesses/#{person_id}.json"
    end

    # GET /projects/1/messages/1.json
    def message message_id
      Message.parse Basecampx.request "projects/#{self.id}/messages/#{message_id}.json"
    end

    def reload!
      self.update_attributes(url ? Basecampx.request(url) : self.class.get_one(self.id))
    end

    private

    def self.get_one project_id
      Basecampx.request "projects/#{project_id}.json"
    end

  end
end