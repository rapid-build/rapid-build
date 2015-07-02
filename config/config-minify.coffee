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

	# init minify
	# ===========
	minify =
		css:
			styles: getOption 'css', 'styles'
			splitMinFile: getOption 'css', 'splitMinFile'
		js:
			scripts: getOption 'js', 'scripts'
			mangle: getOption 'js', 'mangle'
		html:
			views: getOption 'html', 'views'
			templateCache: getOption 'html', 'templateCache'
			options: # not configurable
				conditionals:true, empty:true, ssi:true

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


