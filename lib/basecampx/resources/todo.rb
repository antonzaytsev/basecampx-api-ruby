module Basecampx
  class Todo < Basecampx::Resource

    attr_accessor :id, :todolist_id, :position, :content, :completed, :due_at, :created_at, :updated_at,
                  :comments_count, :creator, :assignee, :comments, :subscribers, :attachments

    def self.find project_id, todo_id
      Todo.new Basecampx.request "projects/#{project_id}/todos/#{todo_id}.json"
    end

  end
end