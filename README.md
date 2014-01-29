# UpFront Wichita IRC Bot

[UpFront Wichita](http://upfrontwichita.com) is a developers group
located in Wichita, Kansas.  We meet once a month to present on a
variety of topics, ranging from front end, back end, and development
tools.

A lot of the members meet daily on our IRC channel, #upfrontwichita on
irc.freenode.net.  This bot provides a couple of fun little niceties,
like automatic URL shortening for all links, a pastie service, and a
user list monitoring service.

## Setup
Getting up and running with this bot is quite simple.  Just follow the
below steps.

    git clone https://github.com/keelerm84/upfront-bot
    cd upfront-bot
    bundle install
    cp config.ini.example config.ini
    ruby bot.rb
