toString = Object.prototype.toString

class Lexer

  constructor: (@structure) ->
    @structure = [@structure] unless toString.call(@structure) is '[object Array]'

  html: ->
    @structure.map (node) ->
      return node if toString.call(node) is '[object String]'
      return '' unless node?
      {type, text, data} = node
      return '' unless lexer.whitelist[type]
      data or= {}
      attrs = ("data-#{k}=\"#{v}\"" for k, v of data)
      return "<#{type} #{attrs.join(' ')}>#{text}</#{type}>"
    .join ''

  text: ->
    @structure.map (node) ->
      return node if toString.call(node) is '[object String]'
      return '' unless node?
      {type, text, data} = node
      return '' unless lexer.whitelist[type]
      return text or ''
    .join ''

  toJSON: -> @structure

  isValid: ->
    @structure.every (obj) ->
      toString.call(obj) is '[object String]' or lexer.whitelist[obj?.type]

lexer = (structure) -> new Lexer(structure)
lexer.name = 'lexer'
lexer.version = 1

# configuration
lexer.whitelist = require './whitelist'

# util functions
lexer.parser = require './parser'

lexer.parseDOM = ->
  structure = lexer.parser.parseDOM.apply lexer.parser, arguments
  new Lexer(structure)

module.exports = lexer
window?.lexer = lexer
