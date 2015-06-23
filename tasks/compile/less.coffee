module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	path         = require 'path'
	es           = require 'event-stream'
	gulpif       = require 'gulp-if'
	less         = require 'gulp-less'
	plumber      = require 'gulp-plumber'
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path
	
	# streams
	# =======
	addToDistPath = -> # add 'styles/' for app and 'rapid-build/styles/' for rb
		transform = (file, cb) ->
			fileName    = path.basename file.path
			basePath    = file.base.replace config.src.app.client.styles.dir, ''
			basePathDup = path.join basePath, basePath
			relPath     = path.join basePathDup, file.relative
			_path       = path.join config.src.app.client.styles.dir, relPath
			file.path   = _path
			cb null, file
		es.map transform

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe less()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = ->
		tasks.run.all(
			config, runTask,
			'styles', 'less',
			['client']
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}less", -> runMulti()
