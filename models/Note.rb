require 'dm-core'
require 'dm-timestamps'

class Note
  include DataMapper::Resource

  property :id, Serial
  property :user_to, String
  property :user_from, String
  property :note, String
  property :created_at, DateTime
end
