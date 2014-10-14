lexer
===

Rich text lexer for teambition projects

# Whitelist

- plain text
- metion

# Example

```coffeescript
data = [{type: 'metion', text: "@user", data: {id: '1'}}, ", Hello"]

# data to html
lexer(data).html()  ==>  '<metion data-id="1">@user</metion>, Hello'

# data to text
lexer(data).text()  ==>  '@user, Hello'

# parseDOM
input = document.getElementById('input')
lex = lexer.parseDOM(input.childNodes)
lex.html()  ==>  '<metion data-id="1">@user</metion>, Hello'
lex.text()  ==>  '@user, Hello'

# parseDOM with options
## lexer will grep the matched username and transfer to a mention tag
lex = lexer.parseDOM(input.childNodes, mention: [{match: 'Grace', data: id: '1'}])

# validate the data
lexer({type: 'mention'}).isValid()  ==>  true
```

# TODO

```
# text
['hello world']
==> 'hello world'

# metion
[{type: 'metion', text: '@user', data: id: '1'}]
==> '<metion data-id="1">@user</metion>'

# link
[{type: 'link', text: 'Teambition', href: 'https://www.teambition.com'}]
==> '<a href="https://www.teambition.com" class="lexer-link" rel="noreferrer" target="_blank">Teambition</a>'
```

# LICENSE

MIT
