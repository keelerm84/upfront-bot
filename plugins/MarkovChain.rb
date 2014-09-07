require 'cinch'
require 'marky_markov'

class MarkovChain
  include Cinch::Plugin

  set :prefix, /^!/

  listen_to :message, method: :on_message

  match /markov (\d+)$/, method: :talk

  def initialize(*args)
    super

    @markov = MarkyMarkov::Dictionary.new('dictionary')
  end

  def on_message(m)
    @markov.parse_string m.message
    @markov.save_dictionary!
  end

  def talk(m, sentence_count)
    m.reply @markov.generate_n_sentences sentence_count.to_i
  end
end
