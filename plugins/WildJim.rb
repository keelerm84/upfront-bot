require 'cinch'

class WildJim
  include Cinch::Plugin

  listen_to :join, method: :on_join
  listen_to :leaving, method: :on_leaving

  def on_join(m)
    if m.user == "jimrice"
      m.reply "** A Wild jimrice appears! **"
    end
  end

  def on_leaving(m, user)
    if user == "jimrice"
      m.reply "** The Wild jimrice flees! **"
    end
  end
end
