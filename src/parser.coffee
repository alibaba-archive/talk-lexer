whitelist = require './whitelist'

strParsers =
  mention: (text, opts) ->
    structure = []
    # buffer for the non-match string
    trunkBuffer = ''

    text.split('@').forEach (trunk, i) ->
      # First trunk
      return trunkBuffer += trunk or '' if i is 0
      for i, opt of opts
        {match, data} = opt
        if trunk.indexOf(match) is 0
          mention = type: 'mention', text: "@#{match}"
          mention.data = data if data?
          structure.push trunkBuffer, mention
          # Reset trunk buffer
          trunkBuffer = trunk[match.length..]
          return true
      trunkBuffer += trunk

    structure.push trunkBuffer
    return structure

parseDOM = (nodes, options) ->
  structure = []
  [0...nodes.length].map (i) ->
    node = nodes[i]
    {tagName} = node
    tagName = tagName.toLowerCase() if tagName?

    # plain text or invalid tags
    unless tagName? and whitelist[tagName]
      text = node.textContent
      return unless text.length  # ignore empty string

      for parser, opts of options
        continue unless typeof strParsers[parser] is 'function'
        text = strParsers[parser].call strParsers, text, opts

      if toString.call(text) is '[object Array]'
        structure = structure.concat text
      else
        structure.push text
      return false

    # parse dom with whitelist tag
    obj = type: tagName, text: node.textContent
    obj.data = {}
    [0...node.attributes?.length].forEach (i) ->
      attr = node.attributes[i]
      [prefix, key] = attr.name.split('-')
      obj.data[key] = attr.value if prefix is 'data' and key?
    return structure.push(obj)
  return structure

module.exports =
  parseDOM: parseDOM
