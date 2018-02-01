module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.compile.typescript.server.enable
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q         = require 'q'
	path      = require 'path'
	ts        = require 'gulp-typescript'
	TsProject = require "#{config.req.helpers}/TsProject"

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
		tsProject = TsProject.get 'server', ts, paths.tsconfig
		tsResult  = tsProject.src().pipe ts tsProject
		reference = if paths.watchFile then [src[0]] else undefined
		tsResult.js
			.pipe ts.filter tsProject, { referencedFrom: reference }
			.pipe gulp.dest paths.dest
			.on 'end', ->
				defer.resolve message: "compiled typescript server"
		defer.promise

	# API
	# ===
	api =
		runSingle: (paths) ->
			paths.watchFile = Task.opts.watchFile.path
			runTask paths

		runMulti: (paths) ->
			runTask(paths).then ->
				log: true
				message: "compiled typescript to: #{paths.dest}"

		init: ->
			_task = if forWatchFile then 'runSingle' else 'runMulti'
			paths = help.getPaths()
			@[_task] paths

	# return
	# ======
	api.init()




