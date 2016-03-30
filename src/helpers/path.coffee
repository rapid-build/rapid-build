module.exports =
	isWin: (path) ->
		path.indexOf('\\') isnt -1

	isWinAbs: (path) ->
		path.indexOf(':\\') isnt -1

	removeDrive: (path) ->
		return path unless @isWinAbs path
		i    = path.indexOf(':\\') + 1
		path = path.substr i

	swapBackslashes: (path) ->
		regx = /\\/g
		path.replace regx, '/'

	formats: (paths) ->
		_paths = []
		return _paths unless Array.isArray paths
		return _paths unless paths.length
		for path in paths
			_paths.push @format path
		_paths

	format: (path) ->
		return path unless @isWin path
		path = @swapBackslashes path
		path

	hasTrailingSlash: (path) ->
		path[path.length-1] is '/'

	removeLocPartial: (locPaths, partial) ->
		paths   = {}
		partial = @format partial
		# partial += '/' unless @hasTrailingSlash partial
		for own k, v of locPaths
			paths[k] = []
			v.forEach (path, i) ->
				paths[k].push v[i].replace partial, ''
		paths

	makeRelative: (path) ->
		return path if path[0] isnt '/'
		path.substr 1


