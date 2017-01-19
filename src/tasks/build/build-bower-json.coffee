module.exports = (config, gulp) ->
	q   = require 'q'
	fse = require 'fs-extra'
	log = require "#{config.req.helpers}/log"

	# helpers
	# =======
	getData = ->
		version      = config.rb.version
		name         = config.rb.name
		dependencies = config.angular.bowerDeps
		{ name, version, dependencies }

	# API
	# ===
	api =
		runTask: (src, dest, file) ->
			defer    = q.defer()
			format   = spaces: '\t'
			json     = getData()
			jsonFile = config.bower.rb.path
			fse.writeJson jsonFile, json, format, (e) ->
				# log.task 'built bower.json', 'minor'
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()

