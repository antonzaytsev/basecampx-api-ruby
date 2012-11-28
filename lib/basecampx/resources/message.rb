module Basecampx
  class Message < Basecampx::Resource

    attr_accessor :id, :subject, :created_at, :updated_at, :content

    has_one :creator, :person
    has_many :comments, :comment
    has_many :subscribers, :person

    #def save
    #  if self.id
    #    params = JSON.parse self.to_json
    #    params.delete 'id'
    #
    #    Basecampx.put "calendars/#{self.id}.json", params
    #  else
    #    params = JSON.parse self.to_json
    #    Basecampx.post "calendars.json", params
    #  end
    #end

  end
end