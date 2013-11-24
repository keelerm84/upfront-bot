require 'cinch'
require './models/Note'

class Notes
  include Cinch::Plugin

  set :prefix, /^!/

  match /note add ([^ ]+) (.+)/, method: :add_note
  match /note del ([0-9]+)/, method: :del_note
  match /note list ([^ ]+)/, method: :list_notes

  listen_to :join, method: :on_join

  def add_note(m, user, note)
    note = Note.new({:user_to => user, :user_from => m.user, :note => note})

    if note.save
      m.reply "Your note for #{user} has been saved"
    else
      m.reply "Something went wrong trying to save your note."
    end
  end

  def del_note(m, id)
    note = Note.get(id)

    if !note
      m.reply "That note doesn't exist."
    elsif note.user_from != m.user
      m.reply "That note doesn't belong to you."
    elsif note.destroy
      m.reply "Note #{id} has been destroyed"
    else
      m.reply "Something went wrong trying to delete your note"
    end
  end

  def list_notes(m, user)
    notes = Note.all(:user_to => user, :user_from => m.user)

    if 0 == notes.size
      m.reply "You have not created any notes for #{user}"
      return
    end

    notes.each do |note|
      m.reply "[#{note.id}] created on #{note.created_at} with message: #{note.note}"
    end
  end

  def on_join(m)
    if m.user == bot
      notify_all_users(m)
    else
      notify_user(m, m.user)
    end
  end

  protected

  def notify_all_users(m)
    users = Array.new
    m.channel.users.each_key do |user|
      next if user == bot || user == "ChanServ"

      notify_user(m, user)
    end
  end

  def notify_user(m, user)
    notes = Note.all(:user_to => user)

    return if 0 == notes.size

    notes.each do |note|
      User(user).send("Note from #{note.user_from} @ #{note.created_at}: #{note.note}")
      note.destroy
    end
  end
end
