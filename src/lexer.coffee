toString = Object.prototype.toString
whitelist = require './whitelist'
parser = require './parser'
stringifier = require './stringifier'

class Lexer

  constructor: (@structure) ->
    @structure = [@structure] unless toString.call(@structure) is '[object Array]'

  html: -> lexer.stringifier.toHtml @structure

  text: -> lexer.stringifier.toText @structure

  toJSON: -> @structure

  isValid: ->
    @structure.every (obj) ->
      toString.call(obj) is '[object String]' or lexer.whitelist[obj?.type]

lexer = (structure) -> new Lexer(structure)
lexer.name = 'lexer'
lexer.version = 1

# configuration
lexer.whitelist = whitelist

# util functions
lexer.parser = parser
lexer.stringifier = stringifier

# Create a structure element
lexer.createElement = (type, text, props) ->
  return text unless whitelist[type]
  ele = type: type, text: text
  ele[k] = v for k, v of props
  ele

lexer.parseDOM = ->
  structure = lexer.parser.parseDOM.apply lexer.parser, arguments
  new Lexer(structure)

module.exports = lexer
window?.lexer = lexer
