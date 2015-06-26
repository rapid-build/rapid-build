module.exports =
	get: (defer) ->
		defer = require('q').defer() if not defer
		defer.resolve()
		defer.promise
