require 'cinch'
require 'date'
require 'rubygems'
require 'action_view'
include ActionView::Helpers::TextHelper

class SecretWord
  include Cinch::Plugin

  @@current_word = ""
  @@last_update
  @@secret_said_count = 0

  set :prefix, /^!/
  match /secretword new$/, method: :force_update_word
  match /secretword count$/, method: :say_count
  match /secretword tellme$/, method: :tell_me
  listen_to :message, method: :on_message

  def initialize(*args)
    super
    update_secret_word
  end

  def on_message(m)
    start_of_today = Date.new(Time.now.year, Time.now.month, Time.now.day).to_time
    if @@last_update < start_of_today
      new_word_output(m)
      update_secret_word
    end
    if /\b#{@@current_word}\b/.match(m.message.downcase)
      m.reply("YOU SAID THE SECRET WORD!!!!")
      m.reply(@@current_word.upcase + "!!! " + @@current_word.upcase + "!!!")
      @@secret_said_count = @@secret_said_count + 1
    end
  end

  def tell_me(m)
    return if !verify_ops(m)
    m.user.send("Psst... The current secret word is '" + @@current_word + "'. Don't tell anyone! :D")
  end

  def say_count(m)
    add_hug = ":D :D :D"
    if @@secret_said_count == 0
      add_hug = ":( :( :("
    end
    m.reply(add_hug + " The secret word has been said " + pluralize(@@secret_said_count, "time") + " " + add_hug)
  end

  def update_secret_word
    new_word = @@current_word
    while new_word == @@current_word
      new_word = find_new_word
      print "Trying out word " + new_word + " against " + @@current_word
    end
    @@current_word = new_word
    @@last_update = Time.now
    @@secret_said_count = 0
  end

  def find_new_word
    chosen_line = nil
    File.foreach("secret_word_list.txt").each_with_index do |line, number|
      chosen_line = line if rand < 1.0/(number+1)
    end
    return chosen_line.strip.downcase
  end

  def force_update_word(m)
    return if !verify_ops(m)
    new_word_output(m)
    update_secret_word
  end

  def new_word_output(m)
    m.reply("A new secret word has been selected!")
    if @@secret_said_count == 0
      m.reply("The previous secret word was '" + @@current_word + "'. NOBODY SAID IT. :( :( :(")
    else
      m.reply("The previous secret word was '" + @@current_word + "'. It was said " + pluralize(@@secret_said_count, "time") + "!")
    end
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
end
