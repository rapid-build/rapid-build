module.exports = (config) ->
	q           = require 'q'
	bower       = require 'bower'
	promiseHelp = require "#{config.req.helpers}/promise"
	bowerHelper = require("#{config.req.helpers}/bower") config

	runTask = (appOrRb) ->
		defer     = q.defer()
		bowerPkgs = bowerHelper.get.pkgs.to.install appOrRb
		return promiseHelp.get defer if not bowerPkgs or not bowerPkgs.length

		bower.commands.install bowerPkgs, force: true,
			directory: ''
			forceLatest: true
			cwd: config.src[appOrRb].client.bower.dir
		.on 'log', (result) ->
			console.log "bower: #{result.id.cyan} #{result.message.cyan}"
		.on 'error', (e) ->
			console.log e
			defer.resolve()
		.on 'end', ->
			defer.resolve()

		defer.promise

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			q.all([
				runTask 'rb'
				runTask 'app'
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()
