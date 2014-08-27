whitelist = require './whitelist'

parseDOM = (nodes) ->
  [0...nodes.length].map (i) ->
    node = nodes[i]
    {tagName} = node
    tagName = tagName.toLowerCase() if tagName?
    # plain text or invalid tags
    return node.textContent unless tagName? and whitelist[tagName]
    obj = type: tagName, text: node.textContent
    obj.data = {}
    [0...node.attributes?.length].forEach (i) ->
      attr = node.attributes[i]
      [prefix, key] = attr.name.split('-')
      obj.data[key] = attr.value if prefix is 'data' and key?
    return obj

module.exports =
  parseDOM: parseDOM
