whitelist = require './whitelist'
toString = Object.prototype.toString

_markLink = (str) ->
  str.replace /(http(s)?:\/\/[^\s]+)/ig, '<a href="$1" target="_blank">$1</a>'

stringifierMap =
  default: (node) ->
    {type, text, data} = node
    data or= {}
    attrs = ("data-#{k}=\"#{v}\"" for k, v of data)
    return "<#{type} #{attrs.join(' ')}>#{text}</#{type}>"

  mention: (node) -> stringifierMap.default node

  link: (node) ->
    {type, href, text} = node
    return """
    <a href="#{href}" class="lexer-link" rel="noreferrer" target="_blank">#{text}</a>
    """

  text: (node) ->
    text = node.text or node
    _markLink(text)

toHtml = (structure) ->
  structure.map (node) ->
    return stringifierMap.text(node) if toString.call(node) is '[object String]'
    return '' unless node?
    {type, text, data} = node
    return '' unless whitelist[type] and typeof stringifierMap[type] is 'function'
    return stringifierMap[type](node)
  .join ''

toText = (structure) ->
  structure.map (node) ->
    return node if toString.call(node) is '[object String]'
    return '' unless node?
    {type, text, data} = node
    return '' unless whitelist[type]
    return text or ''
  .join ''

module.exports =
  toHtml: toHtml
  toText: toText
