module.exports = (config) ->
	q           = require 'q'
	fse         = require 'fs-extra'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	buildFile: (build=true, msg='built') ->
		return promiseHelp.get() unless build
		msg        = 'rebuilt' if msg isnt 'built'
		defer      = q.defer()
		format     = spaces: '\t'
		configFile = config.generated.pkg.config
		fse.writeJson configFile, config, format, (e) ->
			# log.task "#{msg} config.json", 'minor'
			defer.resolve()
		defer.promise

