should = require 'should'
lexer = require '../src/lexer'

util = require './util'

articleHtml = """
Hello, <mention data-id="1">@Grace</mention>. It&apos;s been a long time since we met last time.<br><mention data-id="2">@Bran</mention> is very missing you.
"""

articleText = """
Hello, @Grace. It's been a long time since we met last time.
@Bran is very missing you.\n
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
  ' is very missing you.\n'
]

articleNodes = [
  util.createDOM 'Hello, '
  util.createDOM '@Grace', 'mention', {}, "data-id": "1"
  util.createDOM ". It's been a long time since we met last time.\n"
  util.createDOM '@Bran', 'mention', {}, "data-id": "2"
  util.createDOM ' is very missing you.\n'
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

    # htmlentities
    lex = lexer '<h1>hi</h1>'
    lex.html().should.eql '&lt;h1&gt;hi&lt;/h1&gt;'
    lex.text().should.eql '<h1>hi</h1>'

    # mix text
    lex = lexer articleData
    lex.html().should.eql articleHtml
    lex.text().should.eql articleText

    # test replacement of url
    lexer('I am head http://dn-talk.oss.aliyuncs.com/icons/rss@2x.png I am tail')
    .html().should.eql 'I am head <a href="http://dn-talk.oss.aliyuncs.com/icons/rss@2x.png" target="_blank">http://dn-talk.oss.aliyuncs.com/icons/rss@2x.png</a> I am tail'

  it 'parseDOM', ->

    nodes = [util.createDOM 'hello world']
    lexer.parseDOM nodes
    .toJSON().should.eql ['hello world']

    nodes = [util.createDOM '@user', 'mention', {}, "data-id": "1"]
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

    # create a dom wrapped with div and br
    nodes = [
      util.createDOM 'I am div', 'DIV'
      util.createDOM '', 'BR'
    ]
    lex = lexer.parseDOM nodes
    lex.toJSON().should.eql [
      'I am div\n',
      '\n'
    ]
    lex.text().should.eql 'I am div\n\n'
    lex.html().should.eql 'I am div<br>'

  it 'isValid', ->
    lexer('hello world').isValid().should.eql true

    lexer(['hello world', {type: 'mention', test: '@abc'}]).isValid().should.eql true

    lexer({type: 'men'}).isValid().should.eql false

    lexer([{type: 'men'}]).isValid().should.eql false

  it 'createElement', ->
    lexer.createElement('mention', '@Grace', data: id: 1).should.eql {type: 'mention', text: '@Grace', data: id: 1}
    lexer.createElement('link', 'www.baidu.com', href: 'http://www.baidu.com').should.eql {type: 'link', text: 'www.baidu.com', href: 'http://www.baidu.com'}
    lexer.createElement('undefined', 'hello').should.eql 'hello'

# Test for different types
require './type'
