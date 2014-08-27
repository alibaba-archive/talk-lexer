should = require 'should'
lexer = require '../src/lexer'

util = require './util'

articleHtml = """
Hello, <metion data-id="1">@Grace</metion>. It's been a long time since we met last time.
<metion data-id="2">@Bran</metion> is very missing you.
"""

articleText = """
Hello, @Grace. It's been a long time since we met last time.
@Bran is very missing you.
"""

articleData = [
  'Hello, '
  ,
    type: 'metion'
    text: '@Grace'
    data: id: '1'
  ,
  ". It's been a long time since we met last time.\n"
  ,
    type: 'metion'
    text: '@Bran'
    data: id: '2'
  ,
  ' is very missing you.'
]

articleNodes = [
  util.createDOM 'Hello, '
  util.createDOM '@Grace', 'metion', "data-id": "1"
  util.createDOM ". It's been a long time since we met last time.\n"
  util.createDOM '@Bran', 'metion', "data-id": "2"
  util.createDOM ' is very missing you.'
]

describe 'main', ->

  it 'stringify', ->
    # skip when not in whitelist
    lex = lexer type: 'ack', text: 'nothing'
    lex.html().should.eql ''
    lex.text().should.eql ''

    # text
    lex = lexer 'hello world'
    lex.html().should.eql 'hello world'
    lex.text().should.eql 'hello world'

    # metion
    lex = lexer type: 'metion', text: '@user', data: id: '1'
    lex.html().should.eql '<metion data-id="1">@user</metion>'
    lex.text().should.eql '@user'

    # mix text
    lex = lexer articleData
    lex.html().should.eql articleHtml
    lex.text().should.eql articleText

  it 'parseDOM', ->

    nodes = [util.createDOM 'hello world']
    lexer.parseDOM nodes
    .toJSON().should.eql ['hello world']

    nodes = [util.createDOM '@user', 'metion', "data-id": "1"]
    lexer.parseDOM nodes
    .toJSON().should.eql [{type: 'metion', text: '@user', data: id: '1'}]

    lexer.parseDOM articleNodes
    .toJSON().should.eql articleData
