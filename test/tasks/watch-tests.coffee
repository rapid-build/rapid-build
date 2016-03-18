# watch-tests
# ===========
module.exports = (config, jasmine) ->
	return unless config.test.watch
	gWatch      = require 'gulp-watch'
	Promise     = require 'bluebird'
	testsHelper = require("#{config.paths.abs.test.helpers}/tests") config
	tests       = [ "#{config.paths.abs.test.tests}/**/*" ]

	# helpers
	# =======
	logMsg = (event, test) ->
		test = testsHelper.get.log.path test
		console.log "#{event}: #{test}".info

	# task
	# ====
	createWatch = ->
		new Promise (resolve, reject) ->
			gWatch tests, read:false, (file) ->
				event = file.event
				test  = testsHelper.get.path file.path, 'rel'
				logMsg event, test
				return if event is 'unlink'
				jasmine.init(test).reExecute()
			.on 'ready', ->
				console.log "watching tests".info
				resolve()

	# return
	# ======
	createWatch
