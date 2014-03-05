require 'dm-core'

class RoulettePlayer
  include DataMapper::Resource

  property :id, Serial
  property :player, String
end
