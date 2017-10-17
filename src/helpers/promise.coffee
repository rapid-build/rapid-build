module.exports =
	delay: (delay, defer, resolved) ->
		defer = require('q').defer() unless defer
		setTimeout ->
			defer.resolve resolved
		, delay
		defer.promise

	get: (defer, resolved) ->
		defer = require('q').defer() unless defer
		defer.resolve resolved
		defer.promise