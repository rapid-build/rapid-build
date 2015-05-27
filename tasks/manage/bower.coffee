module.exports = (gulp, config) ->
	q           = require 'q'
	fs          = require 'fs'
	path        = require 'path'
	bower       = require 'bower'
	bowerHelper = require("#{config.req.helpers}/bower") config
	bowerPkgs   = bowerHelper.get.pkgs.to.install()

	gulp.task "#{config.rb.prefix.task}bower", ->
		defer = q.defer()

		return if not bowerPkgs.length
			defer.resolve()
			defer.promise

		bower.commands.install bowerPkgs, force: true,
			directory: ''
			forceLatest: true
			cwd: config.src.rb.client.libs.dir
		.on 'log', (result) ->
			console.log "bower: #{result.id.cyan} #{result.message.cyan}"
		.on 'error', (e) ->
			console.log e
			defer.resolve()
		.on 'end', ->
			defer.resolve()

		defer.promise
