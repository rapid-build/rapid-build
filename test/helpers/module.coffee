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

		delete: (id) -> # recursively, id = module's absolute path
			return unless id
			files    = require.cache[id]
			isCached = !!files
			# console.log "cached #{isCached}:".info, id
			return unless isCached

			children = files.children
			if children.length
				for file in children
					@delete file.id

			delete require.cache[id]