require 'cinch'

class WildJim
  include Cinch::Plugin

  listen_to :join, method: :on_join
  listen_to :part, method: :on_part

  def on_join(m)
    if m.user.nick == "jimrice"
      m.reply "** A Wild jimrice appears! **"
    end
  end

  def on_part(m)
    if m.user.nick == "jimrice"
      m.reply "** The Wild jimrice flees! **"
    end
  end
end
