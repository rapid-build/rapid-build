module.exports = (config, gulp) ->
	q   = require 'q'
	fse = require 'fs-extra'
	log = require "#{config.req.helpers}/log"

	# helpers
	# =======
	getData = ->
		version      = '0.0.0'
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
			jsonFile = config.generated.pkg.bower
			fse.writeJson jsonFile, json, format, (e) ->
				# log.task 'built bower.json', 'minor'
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()

