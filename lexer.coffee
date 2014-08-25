lexer =
  name: 'lexer'
  version: 1

module.exports = lexer if module?.exports
this.lexer = lexer

toString = Object.prototype.toString

# Config
lexer.whitelist =
  text: 1
  metion: 1

# Util functions
lexer.util = {}

# Custom functions and parser
lexer.custom = {}

# Public functions
lexer.stringify = (data) ->
  data = [data] unless toString.call is '[object Array]'
  data.map (d) ->
    {type} = d
    return '' unless lexer.whitelist[type]
    _stringifier = lexer.custom[type]?.stringify or lexer._stringifier
    return _stringifier d
  .join ''

lexer.parse = (str) ->
  # Do nothing

# Private functions
# Default stringify method
lexer._stringifier = (obj) ->
  {type, text, data} = obj
  str = ''
  if type is 'text'  # Pure text
    str = text
  else
    data or= {}
    dataProps = ("data-#{k}=\"#{v}\"" for k, v of data)
    str = "<#{type} #{dataProps.join(' ')}>#{text}</#{type}>"
  return str

# Default parse method
lexer._parser = (str) ->
