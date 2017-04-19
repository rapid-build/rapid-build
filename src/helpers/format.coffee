module.exports = ->
	# helpers
	# =======
	get =
		paths: (paths, opts={}) ->
			opts.join       = opts.join or false
			opts.htmlTag    = opts.htmlTag or null
			opts.attrs      = opts.attrs or null # tag attrs
			opts.lineEnding = opts.lineEnding or '\n'
			_paths = []
			for _path in paths
				break unless opts.htmlTag
				tag = @html[opts.htmlTag] _path, opts
				continue unless tag
				_paths.push tag
			_paths = _paths.join opts.lineEnding if opts.join
			_paths

		html:
			# null attr produces valueless attribute
			# ======================================
			getStringAttrs: (attrs) ->
				strAttrs = ''
				for attr, val of attrs
					continue if val is undefined
					strAttrs += ' '
					strAttrs += if val is null then "#{attr}" else "#{attr}=\"#{val}\""
				strAttrs

			mergeAttrs: (attrs, opts={}) -> # mutator
				return attrs unless opts.attrs
				Object.assign attrs, opts.attrs

			styles: (_path, opts={}) -> # opts.attrs overide default attrs
				attrs = # defaults
					rel: 'stylesheet'
					href: _path

				@mergeAttrs attrs, opts
				strAttrs = @getStringAttrs attrs
				return unless strAttrs
				tag = "<link#{strAttrs}>"

			scripts: (_path, opts={}) -> # opts.attrs overide default attrs
				attrs = # defaults
					src: _path

				@mergeAttrs attrs, opts
				strAttrs = @getStringAttrs attrs
				return unless strAttrs
				tag = "<script#{strAttrs}></script>"

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


