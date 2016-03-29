module.exports =
	get: (defer) ->
		defer = require('q').defer() unless defer
		defer.resolve()
		defer.promise
