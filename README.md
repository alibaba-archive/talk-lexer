lexer
===

Rich text lexer for teambition projects

# Whitelist

- plain text
- mention

# Example

```coffeescript
data = [{type: 'mention', text: "@user", data: {id: '1'}}, ", Hello"]

# data to html
lexer(data).html()  ==>  '<mention data-id="1">@user</mention>, Hello'

# data to text
lexer(data).text()  ==>  '@user, Hello'

# parseDOM
input = document.getElementById('input')
lex = lexer.parseDOM(input.childNodes)
lex.html()  ==>  '<mention data-id="1">@user</mention>, Hello'
lex.text()  ==>  '@user, Hello'

# parseDOM with options
## lexer will grep the matched username and transfer to a mention tag
lex = lexer.parseDOM(input.childNodes, mention: [{match: 'Grace', data: id: '1'}])

# validate the data
lexer({type: 'mention'}).isValid()  ==>  true
```

# TODO

# Types
```
# text
['hello world']
==> hello world

# mention
[{type: 'mention', text: '@user', data: id: '1'}]
==> <mention data-id="1">@user</mention>

# link
[{type: 'link', text: 'Teambition', href: 'https://www.teambition.com'}]
==> <a href="https://www.teambition.com" class="lexer-link" rel="noreferrer" target="_blank">Teambition</a>

# highlight
[{type: 'highlight', text: 'I am blue'}]
==> <em class="lexer-highlight">I am blue</em>
```

# LICENSE

MIT
