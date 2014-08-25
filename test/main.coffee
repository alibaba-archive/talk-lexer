should = require 'should'
lexer = require '../lexer'

describe 'main', ->

  it 'stringify', ->
    # skip when not in whitelist
    lexer.stringify type: 'ack', text: 'nothing'
    .should.eql ''

    # text
    lexer.stringify type: 'text', text: 'hello world'
    .should.eql 'hello world'

    # metion
    lexer.stringify type: 'metion', text: '@user', data: id: '1'
    .should.eql '<metion data-id="1">@user</metion>'

  it 'parse', ->
    # # text
    # lexer.parse 'hello world'
    # .should.eql type: 'text', text: 'hello world'

    # # metion
    # lexer.parse '<metion data-id="1">@user</metion>'
    # .should.eql [{type: 'metion', text: '@user', data: id: '1'}]
