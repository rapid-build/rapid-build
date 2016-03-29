# watch-tests
# ===========
module.exports = (config, jasmine) ->
	return unless config.test.watch
	gWatch  = require 'gulp-watch'
	Promise = require 'bluebird'
	tests   = require("#{config.paths.abs.test.helpers}/tests") config
	specs   = [ "#{config.paths.abs.test.tests.path}/**/*" ]

	# helpers
	# =======
	logMsg = (event, test) ->
		test = tests.get.log.path test
		console.log "#{event}: #{test}".info

	# task
	# ====
	createWatch = ->
		new Promise (resolve, reject) ->
			gWatch specs, read:false, (file) ->
				event = file.event
				test  = tests.get.test file.relative
				logMsg event, test
				return if event is 'unlink'
				jasmine.init(test).reExecute()
			.on 'ready', ->
				console.log "watching tests".info
				resolve()

	# return
	# ======
	createWatch
