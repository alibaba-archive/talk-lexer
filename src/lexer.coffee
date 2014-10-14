toString = Object.prototype.toString

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
lexer.whitelist = require './whitelist'

# util functions
lexer.parser = require './parser'
lexer.stringifier = require './stringifier'

lexer.parseDOM = ->
  structure = lexer.parser.parseDOM.apply lexer.parser, arguments
  new Lexer(structure)

module.exports = lexer
window?.lexer = lexer
