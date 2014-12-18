whitelist = require './whitelist'
toString = Object.prototype.toString

_markLink = (str) ->
  str.replace /(http(s)?:\/\/[\x21-\x7F]+)/ig, '<a href="$1" target="_blank">$1</a>'

_entities = (str) ->
  str.replace /[&<>"']/g, (code) -> "&" + {"&":"amp", "<":"lt", ">":"gt", '"':"quot", "'":"apos"}[code] + ";";

_markNewline = (str) ->
  str.split('\n').join '<br>'

stringifierMap =
  default: (node) ->
    {type, text, data} = node
    data or= {}
    attrs = ("data-#{k}=\"#{v}\"" for k, v of data)
    return "<#{type} #{attrs.join(' ')}>#{_entities(text)}</#{type}>"

  mention: (node) -> stringifierMap.default node

  link: (node) ->
    {type, href, text} = node
    return """
    <a href="#{href}" class="lexer-link" rel="noreferrer" target="_blank">#{_entities(text)}</a>
    """

  highlight: (node) ->
    {type, text} = node
    return """
    <em class="lexer-highlight">#{_entities(text)}</em>
    """

  text: (node) ->
    text = node.text or node
    _markNewline(_markLink(_entities(text)))

toHtml = (structure) ->
  len = structure.length
  structure.map (node, i) ->
    if toString.call(node) is '[object String]'
      node = node.trimRight() if i is (len - 1)  # Trim the \n of last text snippet
      return stringifierMap.text(node)

    {type, text, data} = node
    return '' unless node?
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
