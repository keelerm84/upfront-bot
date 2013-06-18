require 'cinch'
require 'pastie-api'

class CodeChallengeSubmission
    include Cinch::Plugin

    @@extension_mapping = {
        ".m"     => "objective_c",
        ".as"    => "action_script",
        ".rb"    => "ruby",
        ".rails" => "rails",
        ".diff"  => "diff",
        ".txt"   => "plain",
        ".c"     => "c",
        ".cpp"   => "c",
        ".css"   => "css",
        ".java"  => "java",
        ".js"    => "java_script",
        ".html"  => "html",
        ".erb"   => "erb",
        ".sh"    => "bash",
        ".bash"  => "bash",
        ".sql"   => "sql",
        ".php"   => "php",
        ".py"    => "python",
        ".pl"    => "perl",
        ".yml"   => "yaml",
        ".cs"    => "c_sharp"
    }

    listen_to :dcc_send, method: :incoming_dcc
    def incoming_dcc(m, dcc)
        @bot.loggers.debug "Received incoming message"
        file = ""
        dcc.accept(file)

        link, language = post_pastie(file, dcc.filename)

        m.reply "Your pastie has been generated at #{link} tagged as #{language}"
    end

    protected
    def post_pastie(content, filename)
        extension = File.extname(filename)
        language = @@extension_mapping.fetch(extension, "plain")

        @bot.loggers.debug "Extension #{extension} with language #{language}"

        pastie = Pastie.create(content, false, language)
        @bot.loggers.debug "Able to create pastie"
        [pastie.link, language]
    end
end
