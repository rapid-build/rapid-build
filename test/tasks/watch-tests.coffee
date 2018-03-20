# watch-tests
# ===========
module.exports = (config, jasmine) ->
	return unless config.test.watch
	path      = require 'path'
	gulp      = require 'gulp'
	tests     = require("#{config.paths.abs.test.helpers}/tests") config
	testsPath = config.paths.abs.test.tests.path.replace /\\/g, '/' # replace for windows
	specs     = ["#{testsPath}/**/*"]

	# helpers
	# =======
	logMsg = (event, test) ->
		test = tests.get.log.path test
		console.log "#{event}: #{test}".info

	# task
	# ====
	createWatch = ->
		new Promise (resolve, reject) ->
			watcher = gulp.watch specs

			watcher.on 'change', (_path) ->
				relative = path.relative testsPath, _path
				test     = tests.get.test relative
				logMsg 'change', test
				jasmine.init(test).reExecute()

			watcher.on 'error', (e) ->
				console.log "test watcher error".error
				reject e.message

			watcher.on 'ready', ->
				console.log "watching tests".info
				resolve()

	# return
	# ======
	createWatch
