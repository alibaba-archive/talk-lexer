module.exports =
  createDOM: (text, tagName, props = {}, attrs = {}) ->
    node = textContent: text
    return node unless tagName?
    node.tagName = tagName
    node[k] = v for k, v of props
    node.attributes = []
    node.attributes.push(name: k, value: v) for k, v of attrs
    return node
