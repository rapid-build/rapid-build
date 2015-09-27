module.exports = (gulp, config) ->
	q       = require 'q'
	jasmine = require 'gulp-jasmine'

	runTask = (src) ->
		defer = q.defer()
		gulp.src src
			.pipe jasmine()
			.on 'finish', ->
				defer.resolve()
		defer.promise

	runMulti = ->
		src = [].concat(
			config.glob.dist.rb.server.test.js
			config.glob.dist.app.server.test.js
		)
		runTask src

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}run-server-tests", ->
		runMulti()