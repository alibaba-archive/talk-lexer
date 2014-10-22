util = require './util'
lexer = require '../src/lexer'

testcase = (text, html, data, nodes) ->
  lex = lexer(data)
  lex.html().should.eql html
  lex.text().should.eql text

  lex = lexer.parseDOM nodes
  lex.toJSON().should.eql data

describe 'mention', ->

  text = 'Hello, @someone'
  html = """
  Hello, <mention data-id="1">@someone</mention>
  """
  data = [
    "Hello, "
  ,
    type: 'mention'
    text: '@someone'
    data: id: 1
  ]
  nodes = [
    util.createDOM 'Hello, '
    util.createDOM '@someone', 'mention', {}, "data-id": "1"
  ]

  it 'should stringify the mention typed data to mention tag and parse the mention tag to data', ->
    testcase text, html, data, nodes

describe 'link', ->

  text = 'Teambition'
  html = """
  <a href="https://www.teambition.com" class="lexer-link" rel="noreferrer" target="_blank">#{text}</a>
  """
  data = [
    type: 'link'
    href: 'https://www.teambition.com'
    text: text
  ]
  nodes = [util.createDOM text, 'a', href: 'https://www.teambition.com', classList: ['lexer-link']]

  it 'should stringify the link typed data to hyperlink and parse the hyperlink to data', ->
    testcase text, html, data, nodes
