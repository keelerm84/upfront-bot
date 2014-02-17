require 'cinch'
require 'cinch/plugins/identify'
require 'inifile'

require './plugins/CodeChallengeSubmission'
require './plugins/MonitorUsers'
require './plugins/BitlyShortener'
require './plugins/Notes'
require './plugins/Echo'
require './plugins/Michael'

require './models/Note'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup :default, "sqlite:#{Dir.pwd}/db.sqlite3"
DataMapper.auto_upgrade!

config = IniFile.load 'config.ini'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'upfront-bot'
    c.server = 'irc.freenode.org'
    c.channels = ['#upfrontwichita']
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => config['general']['username'],
      :password  => config['general']['password'],
      :type => :nickserv
    }
    c.plugins.plugins = [Cinch::Plugins::Identify, CodeChallengeSubmission, MonitorUsers, BitlyShortener, Notes, Echo, Michael]
  end
end

bot.start
