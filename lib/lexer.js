// Generated by CoffeeScript 1.7.1
(function() {
  var Lexer, lexer, toString;

  toString = Object.prototype.toString;

  Lexer = (function() {
    function Lexer(data) {
      this.data = data;
      if (toString.call(data) !== '[object Array]') {
        this.data = [this.data];
      }
    }

    Lexer.prototype.html = function() {
      return this.data.map(function(node) {
        var attrs, data, k, text, type, v;
        if (toString.call(node) === '[object String]') {
          return node;
        }
        if (node == null) {
          return '';
        }
        type = node.type, text = node.text, data = node.data;
        if (!lexer.whitelist[type]) {
          return '';
        }
        data || (data = {});
        attrs = (function() {
          var _results;
          _results = [];
          for (k in data) {
            v = data[k];
            _results.push("data-" + k + "=\"" + v + "\"");
          }
          return _results;
        })();
        return "<" + type + " " + (attrs.join(' ')) + ">" + text + "</" + type + ">";
      }).join('');
    };

    Lexer.prototype.text = function() {
      return this.data.map(function(node) {
        var data, text, type;
        if (toString.call(node) === '[object String]') {
          return node;
        }
        if (node == null) {
          return '';
        }
        type = node.type, text = node.text, data = node.data;
        if (!lexer.whitelist[type]) {
          return '';
        }
        return text || '';
      }).join('');
    };

    Lexer.prototype.toJSON = function() {
      return this.data;
    };

    return Lexer;

  })();

  lexer = function(data) {
    return new Lexer(data);
  };

  lexer.name = 'lexer';

  lexer.version = 1;

  lexer.whitelist = require('./whitelist');

  lexer.parser = require('./parser');

  lexer.parseDOM = function() {
    var data;
    data = lexer.parser.parseDOM.apply(lexer.parser, arguments);
    return new Lexer(data);
  };

  module.exports = lexer;

  if (typeof window !== "undefined" && window !== null) {
    window.lexer = lexer;
  }

}).call(this);