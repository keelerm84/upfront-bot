require 'cinch'
require 'cinch/plugins/identify'
require 'inifile'

require './plugins/BitlyShortener'
require './plugins/CodeChallengeSubmission'
require './plugins/Echo'
require './plugins/Michael'
require './plugins/MonitorUsers'
require './plugins/Notes'
require './plugins/Roulette'
require './plugins/WildJim'
require './plugins/PHPDocs'
require './plugins/SecretWord'

require './models/Note'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup :default, "sqlite:#{Dir.pwd}/db.sqlite3"
DataMapper.auto_upgrade!

config = IniFile.load 'config.ini'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = config['general']['username']
    c.server = config['general']['server']
    c.channels = config['general']['channels'].split(',')
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => config['general']['username'],
      :password  => config['general']['password'],
      :type => :nickserv
    }
    c.plugins.plugins = [Cinch::Plugins::Identify, CodeChallengeSubmission, MonitorUsers, BitlyShortener, Notes, Echo, Michael, WildJim, Roulette, PHPDocs, SecretWord]
  end
end

bot.start
