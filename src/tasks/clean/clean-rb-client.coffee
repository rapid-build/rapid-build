module.exports = (config, gulp, taskOpts={}) ->
	q           = require 'q'
	del         = require 'del'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	configHelp  = require("#{config.req.helpers}/config") config

	# tasks
	# =====
	cleanRbClient = ->
		defer = q.defer()
		src   = config.dist.rb.client.dir
		del(src, force:true).then (paths) ->
			# log.task 'removed rb client dist dir', 'minor'
			defer.resolve()
		defer.promise

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
			defer = q.defer()
			q.all([
				cleanRbClient()
				rebuildConfig env
			]).done ->
				# log.task 'cleaned rb client dist', 'minor'
				defer.resolve()
			defer.promise

	# return
	# ======
	return promiseHelp.get() unless config.exclude.default.client.files
	api.runTask taskOpts.env

