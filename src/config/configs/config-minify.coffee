module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	test   = require("#{config.req.helpers}/test")()
	isType = require "#{config.req.helpers}/isType"

	# helpers
	# =======
	getOption = (opt, defaultVal) ->
		return defaultVal if isType.null opt
		opt

	getFileName = (opt, defaultVal, ext) ->
		return defaultVal if isType.null opt
		opt = opt.trim()
		return defaultVal unless opt.length
		segs    = opt.split '.'
		lastSeg = segs.pop()
		return "#{lastSeg}.#{ext}" unless segs.length
		segs.push lastSeg unless lastSeg.toLowerCase() is ext
		segs.push ext
		segs.join '.'

	setHtmlMinOpts = (opts, defaultOpts) -> # merge objects
		for opt, val of opts
			if opt is 'ignoreCustomFragments'
				continue unless isType.array val
				[].push.apply defaultOpts[opt], val
				continue
			defaultOpts[opt] = val

	# init minify
	# ===========
	minify =
		cacheBust: getOption options.minify.cacheBust, true
		spa:
			file: getOption options.minify.spa.file, true
		css:
			styles:       getOption options.minify.css.styles, true
			fileName:     getFileName options.minify.css.fileName, 'styles.min.css', 'css'
			splitMinFile: getOption options.minify.css.splitMinFile, false
		html:
			views:         getOption options.minify.html.views, true
			templateCache: getOption options.minify.html.templateCache, true
			options: # configurable
				collapseWhitespace:    true
				removeComments:        true # excludes ie conditionals
				removeEmptyElements:   false
				removeEmptyAttributes: false
				ignoreCustomFragments: [
					/<!--\s*?#\s*?include.*?-->/ig # exclude custom html spa placeholder comments
				]
		client:
			js:
				es6:      getOption options.minify.client.js.es6, false
				enable:   getOption options.minify.client.js.enable, true
				fileName: getFileName options.minify.client.js.fileName, 'scripts.min.js', 'js'
				options:  getOption options.minify.client.js.options, {}
		server:
			js:
				es6:      getOption options.minify.server.js.es6, false
				enable:   getOption options.minify.server.js.enable, true
				options:  getOption options.minify.server.js.options, {}
			json:
				enable:   getOption options.minify.server.json.enable, true

	# html minify options
	# ===================
	setHtmlMinOpts options.minify.html.options, minify.html.options

	# add minify to config
	# ====================
	config.minify = minify

	# logs
	# ====
	# log.json minify, 'minify ='

	# tests
	# =====
	test.log 'true', config.minify, 'add minify to config'

	# return
	# ======
	config


