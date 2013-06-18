require 'cinch'
require 'net/http'
require 'json'

class MonitorUsers
    include Cinch::Plugin

    listen_to :join, method: :on_join
    listen_to :leaving, method: :on_leave

    @@base_url = "http://upfrontwichita.herokuapp.com"

    def on_join(m)
        if m.user == bot
            users = Array.new
            m.channel.users.each_key do |user|
                next if user == bot
                users << {'handle' => user}
            end

            return if 0 ==  users.size

            payload = {'users' => users}
            post_data("#{@@base_url}/irc_users/batch.json", payload)
        else
            payload = {'handle' => m.user}
            post_data("#{@@base_url}/irc_users.json", payload)
        end
    end

    def on_leave(m, user)
        uri = URI.parse("#{@@base_url}/irc_users/#{user}.json")
        header = {'Content-Type' => 'application/json'}

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Delete.new(uri, header)
        http.request(request)
    end

    private

    def post_data(uri, payload)
        uri = URI.parse(uri)
        header = {'Content-Type' => 'application/json'}

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = payload.to_json

        http.request(request)
    end
end
