module.exports =
	cache:
		get: (id) ->
			cache = require.cache
			return null unless cache or cache.length
			cache[id]

		getIds: ->
			cache = require.cache
			return [] unless cache or cache.length
			Object.keys cache

		delete: (id) ->
			Object.keys(require.cache).forEach (id) ->
				delete require.cache[id]