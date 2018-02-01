module.exports =
	delay: (delay, defer, resolved) ->
		if not defer or not defer.fulfill # resolved is 2nd param
			resolved = defer; defer = undefined
		defer = require('q').defer() unless defer
		setTimeout ->
			defer.resolve resolved
		, delay
		defer.promise

	get: (defer, resolved) ->
		if not defer or not defer.fulfill # resolved is 1st param
			resolved = defer; defer = undefined
		defer = require('q').defer() unless defer
		defer.resolve resolved
		defer.promise