require 'cinch'

class Michael
  include Cinch::Plugin

  listen_to :message, method: :glare_command
  def glare_command(m)
    if m.message.match(/\bMichael\b/i) && !m.action?
      m.channel.action("slowly turns and glares at Michael.")
    end
  end
end
