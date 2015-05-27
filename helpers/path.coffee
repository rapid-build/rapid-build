module.exports =
	isWin: (path) ->
		path.indexOf('\\') isnt -1

	isWinAbs: (path) ->
		path.indexOf(':\\') isnt -1

	removeDrive: (path) ->
		return path if not @isWinAbs path
		i    = path.indexOf(':\\') + 1
		path = path.substr i

	swapBackslashes: (path) ->
		regx = /\\/g
		path.replace regx, '/'

	format: (path) ->
		return path if not @isWin path
		path = @removeDrive path
		path = @swapBackslashes path
		path

	hasTrailingSlash: (path) ->
		path[path.length-1] is '/'

	removeLocPartial: (locPaths, partial) ->
		paths = {}
		partial += '/' if not @hasTrailingSlash partial
		for own k, v of locPaths
			paths[k] = []
			v.forEach (path, i) ->
				paths[k].push v[i].replace partial, ''
		paths