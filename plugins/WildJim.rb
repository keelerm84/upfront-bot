require 'cinch'

class WildJim
  include Cinch::Plugin

  listen_to :join, method: :on_join
  listen_to :part, method: :on_part

  def on_join(m)
    if m.user.nick == "jimrice"
      channel.msg("** A Wild jimrice appears! **")
    end
  end

  def on_part(m)
    if m.user.nick == "jimrice"
      channel.msg("** The Wild jimrice flees! **")
    end
  end

  def channel
    Channel('#devict')
  end
end
