docpadConfig =
  env: 'static'

  templateData:
    site:
      title: 'SyntaxHighlighter'
      author: 'Alex Gorbatchev'
      description: 'SyntaxHighlighter description'
      url: 'http://alexgorbatchev.com/SyntaxHighlighter'

    sh_pub_style: (path) ->
      "/pub/sh/current/styles/#{path}"

    sh_pub_script: (path) ->
      "/pub/sh/current/scripts/#{path}"

module.exports = docpadConfig
