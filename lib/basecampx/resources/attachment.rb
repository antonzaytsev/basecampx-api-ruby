module Basecampx
  class Attachment < Basecampx::Resource

    attr_accessor :key, :name, :byte_size, :content_type, :created_at, :url, :attachable

    has_one :creator, :person

    # GET /attachments.json
    def self.all
      self.parse Basecampx.request "/attachments.json"
    end

  end
end