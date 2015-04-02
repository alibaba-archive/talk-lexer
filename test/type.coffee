util = require './util'
lexer = require '../src/lexer'

stringify = (text, html, data, nodes) ->
  lex = lexer(data)
  lex.html().should.eql html
  lex.text().should.eql text

parse = (text, html, data, nodes) ->
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
    data: id: "1"
  ]
  nodes = [
    util.createDOM 'Hello, '
    util.createDOM '@someone', 'mention', {}, "data-id": "1"
  ]

  it 'should stringify the mention typed data to mention tag and parse the mention tag to data', ->
    stringify text, html, data, nodes
    parse text, html, data, nodes

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
    stringify text, html, data, nodes
    parse text, html, data, nodes

describe 'highlight', ->

  text = 'I am blue'
  html = """
  <em class="lexer-highlight">#{text}</em>
  """
  data = [
    type: 'highlight'
    text: text
  ]
  nodes = [util.createDOM text, 'em', classList: ['lexer-highlight']]

  it 'should stringify the highlight block to text and parse the highlight to data', ->
    stringify text, html, data, nodes
    parse text, html, data, nodes

describe 'bold', ->

  text = 'I am bold'
  html = """
  <strong class="lexer-bold">#{text}</strong>
  """
  data = [
    type: 'bold'
    text: text
  ]
  nodes = [util.createDOM text, 'strong', classList: ['lexer-bold']]

  it 'should stringify the bold block to text', ->
    stringify text, html, data, nodes
