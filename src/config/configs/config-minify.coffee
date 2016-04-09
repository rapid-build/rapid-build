module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	test   = require("#{config.req.helpers}/test")()
	isType = require "#{config.req.helpers}/isType"

	# helpers
	# =======
	getOption = (type, opt) ->
		opt = options.minify[type][opt]
		return true if isType.null opt
		opt

	getFileName = (type, lang) ->
		ext    = ".#{lang}"
		fName  = options.minify[lang].fileName
		return "#{type}.min#{ext}" unless fName # default ex: scripts.min.js
		hasExt = fName.indexOf(ext) isnt -1
		fName += ext unless hasExt
		fName

	# init minify
	# ===========
	minify =
		css:
			styles: getOption 'css', 'styles'
			splitMinFile: getOption 'css', 'splitMinFile'
			fileName: getFileName 'styles', 'css'
		js:
			scripts: getOption 'js', 'scripts'
			mangle: getOption 'js', 'mangle'
			fileName: getFileName 'scripts', 'js'
		html:
			views: getOption 'html', 'views'
			templateCache: getOption 'html', 'templateCache'
			options: # configurable
				collapseWhitespace:    true
				removeComments:        true # excludes ie conditionals
				removeEmptyElements:   false
				removeEmptyAttributes: false
				ignoreCustomFragments: [
					/<!--\s*?#\s*?include.*?-->/ig # exclude custom html spa placeholder comments
				]
		spa:
			file: getOption 'spa', 'file'

	# html minify options
	# ===================
	setHtmlMinOpts = ->
		for opt, val of options.minify.html.options
			rbOpts = minify.html.options
			if opt is 'ignoreCustomFragments'
				[].push.apply rbOpts[opt], val
				continue
			rbOpts[opt] = val

	setHtmlMinOpts()

	# cache bust
	# ==========
	cacheBustOpt = options.minify.cacheBust
	minify.cacheBust =
		if isType.null cacheBustOpt then true else cacheBustOpt

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


