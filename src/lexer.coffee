toString = Object.prototype.toString
whitelist = require './whitelist'
parser = require './parser'
stringifier = require './stringifier'
pkg = require '../package.json'

class Lexer

  _trimStruct = (structure) ->
    _struct = []
    tmpNewLines = ''
    structure.forEach (struct, i) ->
      if toString.call(struct) is '[object String]'
        if struct.trim().length is 0  # Empty field, maybe \n
          return unless _struct.length  # Do not save the empty field before non-empty charactors
          return tmpNewLines += struct
      if tmpNewLines.length
        _struct.push tmpNewLines
        tmpNewLines = ''
      _struct.push struct
    _struct

  constructor: (@structure) ->
    @structure = [@structure] unless toString.call(@structure) is '[object Array]'
    @structure = _trimStruct(@structure)

  html: -> lexer.stringifier.toHtml @structure

  text: -> lexer.stringifier.toText(@structure).trim()

  toJSON: -> @structure

  isValid: ->
    @structure.every (obj) ->
      toString.call(obj) is '[object String]' or lexer.whitelist[obj?.type]

lexer = (structure) -> new Lexer(structure)
lexer.name = 'lexer'
lexer.version = pkg.version

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
