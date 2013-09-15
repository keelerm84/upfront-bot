require 'cinch'
require 'bitly'
require 'uri'

class BitlyShortener
  include Cinch::Plugin

  listen_to :message, method: :on_message

  def initialize(*args)
    super

    Bitly.use_api_version_3
    @bitly = Bitly.new("upfrontict", "R_2a0af7fed1d7c47d453e21d823bd461f")
  end

  def on_message(m)
    URI.extract(m.message) do |uri|
      url = @bitly.shorten(uri)
      m.reply url.short_url
    end
  end
end
    

  
