module.exports = ->
	# helpers
	# =======
	get =
		paths: (paths, opts={}) ->
			opts.join       = opts.join or false
			opts.htmlTag    = opts.htmlTag or null
			opts.lineEnding = opts.lineEnding or '\n'
			_paths = []
			paths.forEach (_path) =>
				_paths.push @html[opts.htmlTag] _path if opts.htmlTag
			_paths = _paths.join opts.lineEnding if opts.join
			_paths

		html:
			styles: (_path) ->
				"<link rel=\"stylesheet\" href=\"#{_path}\" />"

			scripts: (_path) ->
				"<script src=\"#{_path}\"></script>"

	# return
	# ======
	json: (data, pretty=true) ->
		return JSON.stringify data, null, '\t' if pretty
		JSON.stringify data

	paths:
		to:
			html: (paths, htmlTag, opts={}) ->
				opts.htmlTag = htmlTag
				get.paths paths, opts