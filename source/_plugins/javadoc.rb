require 'kramdown'

module Jekyll
  class DocTag < Liquid::Tag
    def initialize(tag_name, args, tokens)
      super
      init(args)
    end

    def init(args)
      @@file      = args.strip
      # TODO use config to get the path
      @@full_path = File.expand_path('../syntaxhighlighter/scripts/' + @@file)
      @@source    = File.read(@@full_path)
    end

    def kramdown(source)
      Kramdown::Document.new(source, :auto_ids => false, :footnote_nr => 1).to_html
    end

    def extract_comments_from_file(selector_regex)
      match = @@source.match(@selector_regex)

      raise "Not found" unless match

      pos       = match.pre_match.length
      left_pos  = pos - match.pre_match.reverse.index('**/')
      right_pos = pos + match.to_s.length + match.post_match.index('*/')

      @@source[left_pos, right_pos - left_pos]
    end

    def get_tags(lines)
      line_index = 0

      # find the first line which has a javadoc tag, assume all lines after
      # that are also tags
      lines.each do |line|
        break if line =~ /^@\w+/
        line_index += 1
      end

      # all remaining lines are javadoc tags
      lines = lines[line_index, lines.length - line_index]
      tags = []
      param_regex = /^@(\w+)(\s+(.*))?$/

      lines.each do |line|
        match = line.match(param_regex)

        if match
          tags << {
            :name => match[1],
            :value => (match[3] || '').rstrip
          }
        else
          # need to add a space before the value here, similiar to the way
          # HTML engines treat new lines as a single white character.
          tags.last[:value] << ' ' + line.rstrip if tags.length > 0
        end
      end

      hash = {}

      tags.each do |tag|
        name = tag[:name].to_sym

        tag[:value] = kramdown(tag[:value].strip) if name == :param
        tag[:value] = tag[:value].gsub(/</, '&lt;') if name == :default

        current = hash[name]
        if current
          hash[name] = [ current ] unless current.is_a?(Array)
          hash[name] << tag[:value]
        else
          hash[name] = tag[:value]
        end
      end

      # special case for the :param so that it's always an array for easier
      # and more consistent handling
      hash[:param] = [ hash[:param] ] if hash[:param] and hash[:param].is_a?(String)

      hash
    end

    def get_description(lines)
      description = ''

      # grab all lines up until the first javadoc argument
      lines.each do |line|
        break if line =~ /^@\w+/
        # make sure we don't miss significant empty lines
        line = "\n" if line.strip == ''
        description << line
      end

      kramdown(description)
    end

    def get_comments_block
      comments = extract_comments_from_file(@selector_regex)

      # clean up indents and `*` at the begining of each line
      lines = comments.lines.entries
      lines.reject! { |line| line == '/**' or line == '*/' }
      lines.map! { |line| line.sub(/^\s*\*\s/, '') }

      {
        :description => get_description(lines),
        :tags => get_tags(lines)
      }
    end

    def version(ver)
      return ver ? "<span class=\"label version\" title=\"Introduced in version #{ver}\">#{ver}</span>" : ''
    end

    def slug(str)
      str.gsub(/\W+/, ' ').gsub(/\s+/, ' ').gsub(/\s/, '-').gsub(/^-*|-*$/, '').downcase
    end

    def a(str)
      "<a name=\"#{slug(str)}\">#{str}</a>"
    end
  end

  class DocBaseTag < DocTag
    def init(args)
      @selector       = args.strip
      @selector_regex = /@id (#{Regexp.escape(@selector)})\s*$/
    end

    def render(context)
      get_html(get_comments_block)
    rescue => e
      "<p style=\"background: red; color: white; padding: 2px 4px;\">`#{@selector}` in `#{@@file}`: #{e}</p>"
    end

    def get_html(comments)
      ''
    end
  end

  class DocDescriptionTag < DocBaseTag
    def get_html(comments)
      comments[:description]
    end
  end

  class DocOptTag < DocBaseTag
    def get_html(comments)
      "<div class=\"option\">" +
        "<h4>#{a comments[:tags][:name]} <span class=\"default\">(#{comments[:tags][:default]})</span>#{version comments[:tags][:version]}</h4>" +
        comments[:description] +
      "</div>"
    end
  end

  class DocEventTag < DocBaseTag
    def get_html(comments)
      "<div class=\"event\">" +
        "<h4>#{a comments[:tags][:name]}#{version comments[:tags][:version]}</h4>" +
        comments[:description] +
      "</div>"
    end
  end

  class DocMethodTag < DocBaseTag
    def get_html(comments)
      tags = comments[:tags]
      params = tags[:param]

      if params
        params.map! do |item|
          "<li>#{item}</li>"
        end

        params = "<ul class=\"params\">#{params.join}</ul>"
      end

      "<div class=\"method\">" +
        "<h4>#{a tags[:signature]}#{version tags[:version]}</h4>" +
        (params || '') + 
        comments[:description] +
      "</div>"
    end
  end
end

Liquid::Template.register_tag('doc_file'   , Jekyll::DocTag)
Liquid::Template.register_tag('doc_desc'   , Jekyll::DocDescriptionTag)
Liquid::Template.register_tag('doc_opt'    , Jekyll::DocOptTag)
Liquid::Template.register_tag('doc_event'  , Jekyll::DocEventTag)
Liquid::Template.register_tag('doc_method' , Jekyll::DocMethodTag)

