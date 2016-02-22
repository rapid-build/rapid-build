# watch-tests
# ===========
module.exports = (jasmine) ->
	# requires
	# ========
	path        = require 'path'
	gWatch      = require 'gulp-watch'
	testsHelper = require "#{global.rb.paths.abs.test.helpers}/tests"

	# test files
	# ==========
	tests = testsHelper.get.paths 'default', 'abs'

	# helpers
	# =======
	logMsg = (event, test) ->
		test = testsHelper.get.log.path test
		console.log "#{event}: #{test}".info

	# task
	# ====
	createWatch = ->
		new global.rb.nm.Promise (resolve, reject) ->
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
