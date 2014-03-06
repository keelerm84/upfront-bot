require 'cinch'
require 'open-uri'
require 'uri'

class PHPDocs
  include Cinch::Plugin

  set :prefix, /^!/

  match /php (.+)/, method: :php_doc

  def php_doc(m, func_name)
    # Lookup PHP Docs
    file = open('http://php.net/'+URI.escape(func_name))
    contents = file.read
    contents.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    if !contents.include? "methodsynopsis" or !contents.include? "refpurpose"
      m.reply "Function not found."
      return
    end
    summary = contents.scan /<p class="refpurpose">(.+?)<\/p>/m
    m.reply clean_string summary[0][0]
    result = contents.scan /<div class="methodsynopsis dc-description">(.+?)<\/div>/m
    m.reply clean_string result[0][0]
  end

  def clean_string(inc_string)
    return inc_string
              .gsub(/<[^>]*>/ui,'')
              .gsub(/\n/,'')
              .gsub(/\s\s+/,' ')
              .gsub('&mdash;','-')
              .strip
  end
end
