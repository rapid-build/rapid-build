module.exports = (config) ->
	q           = require 'q'
	log         = require "#{config.req.helpers}/log"
	bower       = require 'bower'
	promiseHelp = require "#{config.req.helpers}/promise"
	bowerHelper = require("#{config.req.helpers}/bower") config

	runTask = (appOrRb, exclude) ->
		return promiseHelp.get() if exclude

		defer     = q.defer()
		bowerPkgs = bowerHelper.get.pkgs.to.install appOrRb
		return promiseHelp.get defer if not bowerPkgs or not bowerPkgs.length

		bower.commands.install bowerPkgs, force: true,
			directory: ''
			forceLatest: true
			cwd: config.src[appOrRb].client.bower.dir
		.on 'log', (result) ->
			log.task "bower: #{result.id} #{result.message}", 'minor'
		.on 'error', (e) ->
			log.task "bower error: #{e.message}", 'error'
			defer.resolve 'error'
		.on 'end', ->
			defer.resolve 'success'

		defer.promise

	# API
	# ===
	api =
		runTask: ->
			defer     = q.defer()
			rbExclude = true if config.exclude.default.client.files
			q.all([
				runTask 'rb', rbExclude
				runTask 'app'
			]).done (result) ->
				switch true
					when result.indexOf('error') != -1
						log.task 'failed to install all bower components', 'error'
					when result.indexOf('success') != -1
						log.task 'installed bower components'
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()
