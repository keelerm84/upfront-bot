require 'cinch'
require './plugins/CodeChallengeSubmission'
require './plugins/MonitorUsers'

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'upfront-bot'
        c.server = 'irc.freenode.org'
        c.channels = ['#upfrontwichita']
        c.plugins.plugins = [CodeChallengeSubmission, MonitorUsers]
    end
end

bot.start
