lexer
===

Rich text lexer for teambition projects

# Whitelist

- plain text
- metion

# Example

```coffeescript
# html
# text
# parseDOM
```

```
# text
['hello world'] ==> 'hello world'

# metion
[{type: 'metion', text: '@user', data: id: '1'}] ==> '<metion data-id="1">@user</metion>'
```

# LICENSE

MIT
