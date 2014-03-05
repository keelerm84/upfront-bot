require 'cinch'

class Echo
  include Cinch::Plugin

  set :prefix, /^!/

  match /say (.+)/, method: :say_command
  match /action (.+)/, method: :action_command
  match /kick ([^ ]+)(.*)/, method: :kick_command

  def say_command(m, command)
    channel.msg(command) if verify_ops(m)
  end

  def action_command(m, command)
    channel.action(command) if verify_ops(m)
  end

  def kick_command(m, user, reason)
    channel.kick(user, reason.strip) if m.user == user || verify_ops(m)
  end

  protected
  def verify_ops(message)
    if ! channel.opped?(message.user)
      message.reply "You have to have ops if you think I'm listening to you."
      false
    else
      true
    end
  end

  def channel
    Channel('#devict')
  end
end
