module TitleHelper
  def title(page, prefix)
    page.title.nil? ? '' : prefix + page.title
  end
end

Webby::Helpers.register(TitleHelper)
