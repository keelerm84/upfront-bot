require 'cinch'

require './plugins/CodeChallengeSubmission'
require './plugins/MonitorUsers'
require './plugins/BitlyShortener'
require './plugins/Notes'

require './models/Note'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup :default, "sqlite:#{Dir.pwd}/db.sqlite3"
DataMapper.auto_upgrade!

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'upfront-bot'
        c.server = 'irc.freenode.org'
        c.channels = ['#upfrontwichita']
        c.plugins.plugins = [CodeChallengeSubmission, MonitorUsers, BitlyShortener, Notes]
    end
end

bot.start
