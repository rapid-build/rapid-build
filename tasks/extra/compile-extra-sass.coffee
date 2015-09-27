module.exports = (gulp, config) ->
	q         = require 'q'
	path      = require 'path'
	sass      = require 'gulp-sass'
	plumber   = require 'gulp-plumber'
	extraHelp = require("#{config.req.helpers}/extra") config
	extCss    = '.css'

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe sass().on 'data', (file) ->
				# needed for empty files. without, ext will stay .scss
				ext = path.extname file.relative
				file.path = file.path.replace ext, extCss if ext isnt extCss
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "compiled extra sass to #{appOrRb} #{loc}".yellow
				defer.resolve()
		defer.promise

	runTasks = (loc) ->
		extraHelp.run.tasks.async runTask, 'compile', 'sass', [loc]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}compile-extra-sass:client", ->
		runTasks 'client'

	gulp.task "#{config.rb.prefix.task}compile-extra-sass:server", ->
		runTasks 'server'