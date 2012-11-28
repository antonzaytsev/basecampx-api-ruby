module Basecampx
  class Topic < Basecampx::Resource

    attr_accessor :id, :title, :excerpt, :created_at, :updated_at, :attachments, :topicable

    has_one :last_updater, :person

    # GET /topics.json
    def self.all
      self.parse Basecampx.request "/topics.json"
    end

  end
end