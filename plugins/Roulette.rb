require 'cinch'
require './models/RoulettePlayer'

class Roulette
  include Cinch::Plugin

  set :prefix, /^!/

  match /roulette list$/, method: :list_players

  match /roulette add$/, method: :add_self
  match /roulette add (.+)?/, method: :add_user

  match /roulette delete$/, method: :delete_self
  match /roulette delete (.+)?/, method: :delete_user

  listen_to :message, method: :on_message

  def on_message(m)
    player = RoulettePlayer.first({ :player => m.user })

    return if !player

    random = (0..1000).to_a.sample

    if 21 == random
      m.channel.kick(m.user, "Bullet to the head.  That has got to hurt!")
    end

  end

  def list_players(m)
    players = RoulettePlayer.all(:order => [ :player.asc ]).to_a.map { |player| player.player }
    m.reply "Current Player List: " + players.join(', ')
  end

  def add_self(m)
    enter_game(m, m.user.nick)
  end

  def add_user(m, user)
    enter_game(m, user)
  end

  def delete_self(m)
    leave_game(m, m.user.nick)
  end

  def delete_user(m, user)
    leave_game(m, user)
  end

  protected

  def verify_ops(message, user)
    if ! message.channel.opped?(message.user) && message.user != user
      message.reply "Only ops can add / delete other users"
      false
    else
      true
    end
  end

  def enter_game(message, user)
    return if !verify_ops(message, user)

    player = RoulettePlayer.first({ :player => user })
    return if player

    RoulettePlayer.create({ :player => user })

    message.reply user + " has been added to the game.  Good luck."
  end

  def leave_game(message, user)
    return if !verify_ops(message, user)

    player = RoulettePlayer.first({ :player => user })

    return if !player

    player.destroy

    message.reply user + " has been removed from the game.  Live to play another day"
  end

end
