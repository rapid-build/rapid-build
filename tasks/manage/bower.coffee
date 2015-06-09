module.exports = (gulp, config) ->
	q           = require 'q'
	bower       = require 'bower'
	bowerHelper = require("#{config.req.helpers}/bower") config

	runTask = (appOrRb) ->
		defer     = q.defer()
		bowerPkgs = bowerHelper.get.pkgs.to.install appOrRb

		return if not bowerPkgs or not bowerPkgs.length
			defer.resolve()
			defer.promise

		bower.commands.install bowerPkgs, force: true,
			directory: ''
			forceLatest: true
			cwd: config.src[appOrRb].client.libs.dir
		.on 'log', (result) ->
			console.log "bower: #{result.id.cyan} #{result.message.cyan}"
		.on 'error', (e) ->
			console.log e
			defer.resolve()
		.on 'end', ->
			defer.resolve()

		defer.promise

	runTasks = ->
		defer = q.defer()
		q.all([
			runTask 'rb'
			runTask 'app'
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}bower",
	["#{config.rb.prefix.task}build-bower-json"], ->
		runTasks()
