require 'cinch'
require 'date'
require 'rubygems'
require 'action_view'
require './models/SecretWord'
include ActionView::Helpers::TextHelper

class SecretWordPlugin
  include Cinch::Plugin

  @@current_word = nil
  @@last_update = Time.now
  @@secret_said_count = 0

  set :prefix, /^!/

  match /secretword new$/, method: :force_update_word
  match /secretword count$/, method: :say_count
  match /secretword tellme$/, method: :tell_me

  match /secretword add (.*)/, method: :add_word
  match /secretword delete (.*)/, method: :delete_word

  listen_to :message, method: :on_message

  def initialize(*args)
    super
    update_secret_word(nil)
  end

  def on_message(m)
    if is_day_change?
      update_secret_word(m)
    end

    if has_current_word && @@current_word.matches(m.message.downcase)
      m.reply("You said the secret word!  It was " + @@current_word.word + ".")
      @@secret_said_count = @@secret_said_count + 1
    end
  end

  def tell_me(m)
    return if !verify_ops(m)

    if !has_current_word
      m.user.send("No word is currently selected.")
    else
      m.user.send("The current secret word is '" + @@current_word.word + "'")
    end
  end

  def say_count(m)
    m.reply("The secret word has been said " + pluralize(@@secret_said_count, "time"))
  end

  def update_secret_word(m)
    @@last_update = Time.now

    if SecretWord.count == 0
      @@current_word = nil
      reply_if_possible(m, "There are no words to choose from.  Please insert some words first.")
      return
    end

    original_word = @@current_word
    new_word = find_new_word

    if new_word.nil?
      m.reply("There are no additional words to choose from.  You must insert more words.")
      return
    end

    @@current_word = new_word
    new_word_output(m, original_word)

    @@secret_said_count = 0
  end

  def find_new_word
    not_equal = has_current_word ? @@current_word.word : ''
    size_of_list = has_current_word ? SecretWord.count - 1 : SecretWord.count
    return SecretWord.first(:offset => rand(size_of_list), :conditions => { :word.not => not_equal })
  end

  def force_update_word(m)
    return if !verify_ops(m)
    update_secret_word(m)
  end

  def new_word_output(m, original_word)
    reply_if_possible(m, "A new secret word has been selected.")

    return if original_word.nil?

    last_word = "The previous secret word was '" + original_word.word + "'."
    if @@secret_said_count == 0
      reply_if_possible(m, last_word + "  Nobody said it.")
    else
      reply_if_possible(m, last_word + "  It was said " + pluralize(@@secret_said_count, "time") + ".")
    end
  end

  def add_word(m, word)
    return if !verify_ops(m)

    word.downcase!

    if SecretWord.first({ :word => word })
      m.reply(word + " is already in the list")
      return
    end

    SecretWord.create({ :word => word })

    m.reply word + " has been added."
  end

  def delete_word(m, word)
    return if !verify_ops(m)

    word.downcase!
    secret_word = SecretWord.first({ :word => word })

    if !secret_word
      m.reply(word + " does not exist in the list")
      return
    end

    secret_word.destroy

    m.reply word + " has been deleted."
  end

  protected

  def verify_ops(m)
    if ! m.channel.opped?(m.user)
      m.reply("Get out of here! Only ops can tell me what to do!")
      false
    else
      true
    end
  end

  def is_day_change?
    start_of_today = Date.new(Time.now.year, Time.now.month, Time.now.day).to_time
    return @@last_update < start_of_today
  end

  def has_current_word
    return !@@current_word.nil?
  end

  def reply_if_possible(m, phrase)
    return if m.nil?

    m.reply(phrase)
  end
end
