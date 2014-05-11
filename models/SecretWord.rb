require 'dm-core'

class SecretWord
  include DataMapper::Resource

  property :id, Serial
  property :word, String, :required => true

  def matches(w)
    /\b#{@word}\b/.match(w.downcase)
  end
end
