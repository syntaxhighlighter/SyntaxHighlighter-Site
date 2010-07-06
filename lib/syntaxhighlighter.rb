module SyntaxHighlighterHelper
  DEBUG = false
  
  def sh_version
    "3.0.83"
  end
  
  def sh_pub
    '/pub/sh/current'
  end
  
  def sh_pub_script(file = '')
    file = '/' + file if file != ''
    "#{sh_pub}/scripts#{file}"
  end

  def sh_pub_style(file = '')
    file = '/' + file if file != ''
    "#{sh_pub}/styles#{file}"
  end
  
  def sh_title(page, prefix)
    page.title.nil? ? '' : prefix + page.title
  end
end

Webby::Helpers.register(SyntaxHighlighterHelper)
