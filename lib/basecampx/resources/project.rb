module Basecampx
  class Project < Basecampx::Resource

    attr_accessor :id, :name, :description, :archived, :created_at, :updated_at, :starred, :url

    def self.all
      Project.parse Basecampx.request "projects.json"
    end

    def self.find project_id
      Project.new Basecampx.request "projects/#{project_id}.json"
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
    def revoke_access person_id
      if person_id.class.name == 'Basecampx::Person'
        person_id = person_id.id
      end

      Basecampx.delete "projects/#{self.id}/accesses/#{person_id}.json"
    end

    # GET /projects/1/messages/1.json
    def message message_id
      Message.parse Basecampx.request "projects/#{self.id}/messages/#{message_id}.json"
    end

  end
end