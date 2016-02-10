module.exports = (config) ->
	q           = require 'q'
	fse         = require 'fs-extra'
	promiseHelp = require "#{config.req.helpers}/promise"

	buildFile: (build=true, msg='built') ->
		return promiseHelp.get() unless build
		msg        = 'rebuilt' if msg isnt 'built'
		defer      = q.defer()
		format     = spaces: '\t'
		configFile = config.generated.pkg.config
		fse.writeJson configFile, config, format, (e) ->
			console.log "#{msg} config.json".yellow
			defer.resolve()
		defer.promise

