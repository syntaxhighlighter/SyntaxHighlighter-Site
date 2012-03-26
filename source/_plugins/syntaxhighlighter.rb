require 'kramdown'

module Jekyll
  class Site
    alias jekyll_process process
    alias jekyll_render render

    def render
      # sort pages by title
      @pages.sort! do |p1, p2|
        p1 = p1.data['title'] or ''
        p2 = p2.data['title'] or ''
        if p1 == p2
          0
        else
          p1 > p2 ? 1 : -1
        end
      end

      jekyll_render
    end

    def process
      jekyll_process

      from = File.expand_path(config['syntaxhighlighter'])
      to   = File.expand_path(config['destination'] + '/syntaxhighlighter')
      `ln -s \"#{from}\" \"#{to}\"`
      puts "Created SyntaxHighlighter symlink"

      `cd bin && ./less`
      puts "Updated less"
    end
  end

  # patch the render method so that it doesn't exclude symlinks
  class IncludeTag < Liquid::Tag
    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_includes')

      Dir.chdir(includes_dir) do
        choices = Dir['**/*']
        if choices.include?(@file)
          source = File.read(@file)
          partial = Liquid::Template.parse(source)
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end
end

Liquid::Template.register_tag('include', Jekyll::IncludeTag)
