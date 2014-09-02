should = require 'should'
lexer = require '../src/lexer'

util = require './util'

articleHtml = """
Hello, <mention data-id="1">@Grace</mention>. It's been a long time since we met last time.
<mention data-id="2">@Bran</mention> is very missing you.
"""

articleText = """
Hello, @Grace. It's been a long time since we met last time.
@Bran is very missing you.
"""

articleData = [
  'Hello, '
  ,
    type: 'mention'
    text: '@Grace'
    data: id: '1'
  ,
  ". It's been a long time since we met last time.\n"
  ,
    type: 'mention'
    text: '@Bran'
    data: id: '2'
  ,
  ' is very missing you.'
]

articleNodes = [
  util.createDOM 'Hello, '
  util.createDOM '@Grace', 'mention', "data-id": "1"
  util.createDOM ". It's been a long time since we met last time.\n"
  util.createDOM '@Bran', 'mention', "data-id": "2"
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

    # mention
    lex = lexer type: 'mention', text: '@user', data: id: '1'
    lex.html().should.eql '<mention data-id="1">@user</mention>'
    lex.text().should.eql '@user'

    # mix text
    lex = lexer articleData
    lex.html().should.eql articleHtml
    lex.text().should.eql articleText

  it 'parseDOM', ->

    nodes = [util.createDOM 'hello world']
    lexer.parseDOM nodes
    .toJSON().should.eql ['hello world']

    nodes = [util.createDOM '@user', 'mention', "data-id": "1"]
    lexer.parseDOM nodes
    .toJSON().should.eql [{type: 'mention', text: '@user', data: id: '1'}]

    lexer.parseDOM articleNodes
    .toJSON().should.eql articleData

    # pass option params to parseDOM method
    nodes = [util.createDOM 'Hello @Graceand@Bran Good Afternoon']
    lexer.parseDOM nodes, mention: [{match: 'Grace', data: id: '1'}, {match: 'Bran', data: id: '2'}]
    .toJSON().should.eql [
      'Hello '
      type: 'mention', text: '@Grace', data: id: '1'
      'and'
      type: 'mention', text: '@Bran', data: id: '2'
      ' Good Afternoon'
    ]

    # do not break emails
    nodes = [util.createDOM 'Hello user@gmail.com']
    lexer.parseDOM nodes, mention: [{match: 'user', data: id: '2'}]
    .toJSON().should.eql [
      'Hello user@gmail.com'
    ]

  it 'isValid', ->
    lexer('hello world').isValid().should.eql true

    lexer(['hello world', {type: 'mention', test: '@abc'}]).isValid().should.eql true

    lexer({type: 'men'}).isValid().should.eql false

    lexer([{type: 'men'}]).isValid().should.eql false
