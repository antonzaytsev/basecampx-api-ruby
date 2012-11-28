module Basecampx
  class Calendar < Basecampx::Resource

    attr_accessor :id, :name, :created_at, :updated_at, :accesses, :calendar_events

    has_one :creator, :person

    def self.find calendar_id
      self.new Basecampx.request "calendars/#{calendar_id}.json"
    end

    def self.all
      self.parse Basecampx.request "calendars.json"
    end

    def save
      # PUT /calendars/1.json
      if self.id
        params = JSON.parse self.to_json
        params.delete 'id'

        Basecampx.put "calendars/#{self.id}.json", params
      else
        params = JSON.parse self.to_json
        Basecampx.post "calendars.json", params
      end
    end

  end
end