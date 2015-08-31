module.exports = (gulp, config) ->
	q    = require 'q'
	del  = require 'del'
	path = require 'path'

	cleanTask = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# console.log 'cleaned rb test src'.yellow
			defer.resolve()
		defer.promise

	runTask = ->
		dest = config.src.rb.client.test.dir
		src  = [
			path.join dest, '*'
			path.join "!#{dest}", '.gitkeep'
		]
		cleanTask src

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}clean-rb-test-src", ->
		runTask() # all files are generated

