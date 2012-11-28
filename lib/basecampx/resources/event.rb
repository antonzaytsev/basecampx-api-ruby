module Basecampx
  class Event < Basecampx::Resource

    attr_accessor :id, :created_at, :updated_at, :summary, :url

    mount :creator, :person
    mount :bucket, :project

    def self.all since=1.day.ago
      Event.parse Basecampx.request "events.json?since=#{since.to_time.iso8601}"
    end

  end
end