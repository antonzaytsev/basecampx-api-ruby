module Basecampx
  class Resource

    extend Basecampx::Relations

    class << self
      def parse json
        output = []

        json.each do |user|
          output << self.new(user)
        end

        output
      end

      def update_url=url
        @update_url = url
      end

      def update_url
        @update_url
      end

      def create_url=url
        @create_url = url
      end

      def create_url
        @create_url
      end
    end

    def initialize args=[]
      self.original_data = args
      self.update_attributes args
    end

    def update_attributes args
      args.each do |key, value|
        self.send(key.to_s+'=', value) if self.respond_to?((key.to_s+'=').to_s)
      end
      self
    end

    def save
      if is_new?
        create
      else
        update
      end
    end

    def is_new?
      !self.id
    end

    def is_changed?

    end

protected

    def original_data
      @original_data
    end

    def original_data=data
      @original_data = data
    end

    def update
      data = {}
      accessors.each do |accessor|
        value = self.send accessor
        if value.class.name == 'Basecampx::Person'
          if value.respond_to?(:id) && value.id
            value = {id: value.id, type: 'Person'}
          end
        end
        data[accessor] = value
      end

      resp = Basecampx.put "/projects/#{self.project.id}/todos/#{self.id}.json", body: data

      if resp
        self.update_attributes resp
        true
      else
        false
      end
    end


    def create

      if !self.project || !self.project.id || !self.todolist_id
        return false
      end

      data = {}
      accessors.each do |accessor|
        value = self.send accessor
        if value.class.name == 'Basecampx::Person'
          if value.respond_to?(:id) && value.id
            value = {id: value.id, type: 'Person'}
          end
        end
        data[accessor] = value
      end

      resp = Basecampx.post "/projects/#{self.project.id}/todolists/#{self.todolist_id}/todos.json", body: data

      if resp
        self.update_attributes resp
        true
      else
        false
      end
    end

  end
end