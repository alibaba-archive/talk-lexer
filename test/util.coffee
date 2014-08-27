module.exports =
  createDOM: (text, tagName, attrs = {}) ->
    node = textContent: text
    return node unless tagName?
    node.tagName = tagName
    node.attributes = []
    node.attributes.push(name: k, value: v) for k, v of attrs
    return node
