module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.exclude.default.client.files

	# requires
	# ========
	q          = require 'q'
	del        = require 'del'
	configHelp = require("#{config.req.helpers}/config") config

	# tasks
	# =====
	cleanRbClient = ->
		src = config.dist.rb.client.dir
		del(src, force:true).then (paths) ->
			message: "removed rb client dist dir"

	rebuildConfig = (env) ->
		return promiseHelp.get() if env is 'test'
		return promiseHelp.get() if config.spa.custom
		return promiseHelp.get() if config.exclude.spa
		config.exclude.spa = true
		configHelp.buildFile true, 'rebuild'

	# API
	# ===
	api =
		runTask: (env) ->
			q.all([
				cleanRbClient()
				rebuildConfig env
			]).then ->
				# log: 'minor'
				message: "cleaned rb client dist"

	# return
	# ======
	api.runTask Task.opts.env

