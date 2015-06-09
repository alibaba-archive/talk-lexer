all: dist test

dist:
	coffee -o lib -c src
	browserify --bare lib/lexer.js > dist/lexer.js
	uglifyjs dist/lexer.js > dist/lexer.min.js

test:
	@NODE_ENV=mocha ./node_modules/.bin/mocha \
	        --require coffee-script/register \
		--require should \
		--reporter spec test/main.coffee

.PHONY: all test dist
