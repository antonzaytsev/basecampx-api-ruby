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

      def delete_url=url
        @delete_url = url
      end

      def delete_url
        @delete_url
      end
    end

    def errors
      @_errors
    end

    def initialize args=[]
      self.original_data = args
      self.update_attributes args
      @_errors = []
    end

    def update_attributes args
      args.each do |key, value|
        self.send(key.to_s+'=', value) if self.respond_to?((key.to_s+'=').to_s)
      end
      self
    end

    def save
      if new?
        create
      elsif changed?
        update
      else
        false
      end
    end

    def new?
      !self.id
    end

    def changed?
      true # TODO: added checking if record changed
    end

    def destroy
      if self.class.delete_url
        url = self.class.delete_url.call self
        Basecampx.delete url
        return true
      end
      false
    end

protected

    def original_data
      @original_data
    end

    def original_data=data
      @original_data = data
    end

    def update
      unless self.class.update_url
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

      url = self.class.update_url.call self
      resp = Basecampx.put url, body: data

      if resp
        self.update_attributes resp
        true
      else
        false
      end
    end

    def create
      if !self.class.create_url
        @_errors << 'create_url is not specified'
        return false
      end

      if self.class.name =~ /::Todo$/ && !self.todolist_id
        @_errors << 'please specify todolist_id'
        return false
      end

      if self.class.name =~ /::TodoList$/ && (!self.bucket || !self.bucket.id)
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

      url = self.class.create_url.call self
      resp = Basecampx.post url, body: data

      if resp
        self.update_attributes resp
        true
      else
        false
      end
    end

  end
end