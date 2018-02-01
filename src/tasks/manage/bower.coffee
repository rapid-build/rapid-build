module.exports = (config, gulp, Task) ->
	q           = require 'q'
	log         = require "#{config.req.helpers}/log"
	bower       = require 'bower'
	promiseHelp = require "#{config.req.helpers}/promise"
	bowerHelper = require("#{config.req.helpers}/bower") config

	runTask = (appOrRb, exclude) ->
		defer = q.defer()

		return promiseHelp.get defer if exclude
		bowerPkgs = bowerHelper.get.pkgs.to.install appOrRb
		return promiseHelp.get defer if not bowerPkgs or not bowerPkgs.length

		bower.commands.install bowerPkgs, force: true,
			directory: ''
			forceLatest: true
			cwd: config.src[appOrRb].client.bower.dir
		.on 'error', (e) -> defer.reject e
		.on 'log', (result) ->
			log.task "bower: #{result.id} #{result.message}", 'minor'
		.on 'end', ->
			defer.resolve 'success'

		defer.promise

	# API
	# ===
	api =
		runTask: ->
			rbExclude = true if config.exclude.default.client.files
			q.all([
				runTask 'rb', rbExclude
				runTask 'app'
			]).then (result) ->
				switch true
					when result.indexOf('error') != -1
						log: 'error'
						message: 'failed to install all bower components'
					when result.indexOf('success') != -1
						log: true
						message: 'installed bower components'
					else
						message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()
