toString = Object.prototype.toString

class Lexer

  constructor: (@data) ->
    @data = [@data] unless toString.call(data) is '[object Array]'

  html: ->
    @data.map (node) ->
      return node if toString.call(node) is '[object String]'
      return '' unless node?
      {type, text, data} = node
      return '' unless lexer.whitelist[type]
      data or= {}
      attrs = ("data-#{k}=\"#{v}\"" for k, v of data)
      return "<#{type} #{attrs.join(' ')}>#{text}</#{type}>"
    .join ''

  text: ->
    @data.map (node) ->
      return node if toString.call(node) is '[object String]'
      return '' unless node?
      {type, text, data} = node
      return '' unless lexer.whitelist[type]
      return text or ''
    .join ''

  toJSON: -> @data

lexer = (data) -> new Lexer(data)
lexer.name = 'lexer'
lexer.version = 1

# configuration
lexer.whitelist = require './whitelist'

# util functions
lexer.parser = require './parser'

lexer.parseDOM = ->
  data = lexer.parser.parseDOM.apply lexer.parser, arguments
  new Lexer(data)

module.exports = lexer
window?.lexer = lexer
