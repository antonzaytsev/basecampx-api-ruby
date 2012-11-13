module Basecampx
  class Resource
    class << self
      def parse json
        output = []

        json.each do |user|
          output << self.new(user)
        end

        output
      end
    end

    def initialize args=[]
      self.update_details args
    end

    def update_details args
      args.each do |key, value|
        self.send(key.to_s+'=', value) if self.respond_to?((key.to_s+'=').to_s)
      end
    end

    def save
      # TODO: add ability to create/update/save/delete resources
    end

    def delete

    end
  end
end