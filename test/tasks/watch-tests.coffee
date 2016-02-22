# watch-tests
# =========
module.exports = (jasmine) ->
	path     = require 'path'
	gWatch   = require 'gulp-watch'
	testsAbs = global.rb.paths.abs.test.tests
	testsRel = global.rb.paths.rel.test.tests
	tests    = path.join testsAbs, '**', '*.*'

	# helpers
	# =======
	getTest = (testRel) ->
		path.join testsRel, testRel

	logMsg = (event, test) ->
		test = test.replace global.rb.paths.rel.test.path, ''
		console.log "#{event}: #{test}".info

	# task
	# ====
	createWatch = ->
		new global.rb.nm.Promise (resolve, reject) ->
			gWatch tests, read:false, (file) ->
				event = file.event
				test  = getTest file.relative
				logMsg event, test
				return if event is 'unlink'
				jasmine.init(test).reExecute()
			.on 'ready', ->
				console.log "watching tests".info
				resolve()

	# return
	# ======
	createWatch
