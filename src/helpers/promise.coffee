module.exports =
	delay: (delay, defer) ->
		defer = require('q').defer() unless defer
		setTimeout ->
			defer.resolve()
		, delay
		defer.promise

	get: (defer) ->
		defer = require('q').defer() unless defer
		defer.resolve()
		defer.promise