all: dist test

dist:
	coffee -o lib -c src
	browserify --bare lib/lexer.js > dist/lexer.js
	uglifyjs dist/lexer.js > dist/lexer.min.js

bump:
	make dist && gulp bump

test:
	@NODE_ENV=mocha ./node_modules/.bin/mocha \
		--require should \
		--reporter spec test/index.js

.PHONY: all test dist
