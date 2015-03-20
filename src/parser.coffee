whitelist = require './whitelist'
toString = Object.prototype.toString

invalidNodeType = [8]

parserMap =
  # Save the tagName as type
  # And pick the data attributes from 'data-' properties
  default: (node) ->
    {tagName, nodeType, textContent} = node
    obj = type: tagName.toLowerCase(), text: node.textContent
    obj.data = {}
    [0...node.attributes?.length].forEach (i) ->
      attr = node.attributes[i]
      [prefix, key] = attr.name.split('-')
      obj.data[key] = attr.value if prefix is 'data' and key?
    return obj

  mention: (node, opts) ->
    {tagName, nodeType, textContent} = node
    return parserMap.default(node) if tagName is 'MENTION'

    # If the node have a tagName, it couldn't be plain text
    return false if tagName

    structure = []
    # buffer for the non-match string
    sectionBuffer = ''
    textContent.split('@').forEach (section, i) ->
      # First section
      return sectionBuffer += section or '' if i is 0
      for i, opt of opts
        {match, data} = opt
        if section.indexOf(match) is 0
          mention = type: 'mention', text: "@#{match}"
          mention.data = data if data?
          structure.push sectionBuffer, mention
          # Reset section buffer
          sectionBuffer = section[match.length..]
          return true
      sectionBuffer += "@#{section}"

    structure.push sectionBuffer
    return structure

  link: (node, opts) ->
    {tagName, nodeType, classList, href, textContent} = node
    classList or= []
    # Valid lexer link should have a `lexer-link` class
    # And the tagName should be `a`
    return false unless 'lexer-link' in classList and tagName is 'A'

    type: 'link'
    href: href
    text: textContent

  highlight: (node, opts) ->
    {tagName, nodeType, classList, href, textContent} = node
    classList or= []
    return false unless 'lexer-highlight' in classList and tagName is 'EM'

    type: 'highlight'
    text: textContent

parseDOM = (nodes, options = {}) ->
  structure = []

  [0...nodes.length].forEach (i) ->
    node = nodes[i]
    {nodeType, tagName} = node

    # Strip comments
    return if nodeType in invalidNodeType

    return structure.push('\n') if tagName is 'BR'

    # Apply each whitelist function on the node
    judge = Object.keys(whitelist).some (parserKey) ->
      return false unless typeof parserMap[parserKey] is 'function'
      obj = parserMap[parserKey] node, options[parserKey]
      if toString.call(obj) is '[object Array]'
        structure = structure.concat obj
      else if obj
        structure.push obj
      return obj

    # The node pass through all the parsers and could not find a valid one
    # Then pick the plain text of the node
    unless judge
      text = node.textContent
      return unless text.length
      if tagName in ['DIV', 'P', 'BLOCKQUOTE', 'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'LI']
        # Append \n when use div at first place
        # Or the pre tag is end up with \n
        if i is 0 or structure[structure.length - 1]?[-1..] is '\n'
          text += '\n'
        else
          text = '\n' + text + '\n'
      return structure.push(text)

  return structure

module.exports =
  parseDOM: parseDOM
