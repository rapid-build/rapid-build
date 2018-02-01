module.exports = (config) ->
	fse         = require 'fs-extra'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	buildFile: (build=true, msg='built') -> # :Promise
		return promiseHelp.get() unless build
		msg        = 'rebuilt' if msg isnt 'built'
		format     = spaces: '\t'
		configFile = config.generated.pkg.config
		fse.writeJson(configFile, config, format).then ->
			result = message: "#{msg} config.json"
			# log.task result.message, 'minor'
			result

