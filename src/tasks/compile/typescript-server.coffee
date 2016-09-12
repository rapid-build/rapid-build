module.exports = (config, gulp, taskOpts={}) ->
	q              = require 'q'
	path           = require 'path'
	ts             = require 'gulp-typescript'
	log            = require "#{config.req.helpers}/log"
	promiseHelp    = require "#{config.req.helpers}/promise"
	TsProject      = require "#{config.req.helpers}/TsProject"
	updateFileBase = require "#{config.req.plugins}/gulp-update-file-base"
	forWatchFile   = !!taskOpts.watchFile

	# helpers
	# =======
	help =
		getPaths: ->
			paths =
				src:  config.src.app.server.dir
				dest: config.dist.app.server.dir
				glob: config.glob.src.app.server.scripts.ts
			paths.tsconfig = path.join paths.src, 'tsconfig.json'
			paths

		getSrc: (paths) ->
			src = paths.watchFile or paths.glob
			[].concat src, config.glob.src.app.server.typings.defs

	# tasks
	# =====
	runTask = (paths) ->
		defer     = q.defer()
		src       = help.getSrc paths
		fileBase  = paths.src
		tsProject = TsProject.get 'server', ts, paths.tsconfig
		tsResult  = tsProject.src(src).pipe ts tsProject
		reference = if paths.watchFile then [src[0]] else undefined
		tsResult.js
			.pipe ts.filter tsProject, { referencedFrom: reference }
			.pipe gulp.dest paths.dest
			.on 'end', -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: (paths) ->
			paths.watchFile = taskOpts.watchFile.path
			runTask paths

		runMulti: (paths) ->
			promise = runTask paths
			promise.done ->
				log.task "compiled typescript to: #{paths.dest}"
			promise

		init: ->
			return promiseHelp.get() unless config.compile.typescript.server.enable
			task  = if forWatchFile then 'runSingle' else 'runMulti'
			paths = help.getPaths()
			@[task] paths

	# return
	# ======
	api.init()




