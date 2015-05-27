module.exports =
	cache:
		delete: (modulePath) ->
			isCached = !!require.cache[modulePath]
			delete require.cache[modulePath] if isCached
			isCached