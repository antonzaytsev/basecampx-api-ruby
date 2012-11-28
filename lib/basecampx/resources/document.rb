module Basecampx
  class Document < Basecampx::Resource

    attr_accessor :id, :title, :content, :created_at, :updated_at, :url

    has_one :last_updater, :person
    has_many :comments, :comment
    has_many :subscribers, :person

    # GET /documents.json
    def self.all
      self.parse Basecampx.request "/documents.json"
    end

    def details
      update_details self.url
    end

private

    def update_details url=nil
      self.update_attributes Basecampx.request(url || "documents/#{self.id}.json")
      self
    end

  end
end