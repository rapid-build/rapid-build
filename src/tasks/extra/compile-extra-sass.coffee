module.exports = (config, gulp, taskOpts={}) ->
	q         = require 'q'
	path      = require 'path'
	sass      = require 'gulp-sass'
	plumber   = require 'gulp-plumber'
	log       = require "#{config.req.helpers}/log"
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
				log.task "compiled extra sass to: #{config.dist.app[loc].dir}"
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			extraHelp.run.tasks.async runTask, 'compile', 'sass', [loc]

	# return
	# ======
	api.runTask taskOpts.loc