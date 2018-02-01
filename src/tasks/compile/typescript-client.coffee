module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.compile.typescript.client.enable

	# requires
	# ========
	q          = require 'q'
	fs         = require 'fs'
	path       = require 'path'
	tsify      = require 'tsify'
	watchify   = require 'watchify'
	fse        = require 'fs-extra'
	browserify = require 'browserify'
	source     = require 'vinyl-source-stream'
	log        = require "#{config.req.helpers}/log"

	# helpers
	# =======
	help =
		getBrowserify: (opts) ->
			browserify(opts.b).plugin tsify, opts.ts

		getOpts: (paths) ->
			bundleFile = 'bundle.js'
			bundlePath = path.join paths.dest.scripts, bundleFile
			b:
				basedir: paths.src.scripts
				entries: config.compile.typescript.client.entries
				cache:        {}
				packageCache: {}
			ts:
				project: paths.tsconfig
			watch:
				ignoreWatch: ['**/node_modules/**', '**/typings/**/*.d.ts']
			bundle:
				path:     bundlePath
				fileName: bundleFile

		getPaths: ->
			paths =
				src:
					dir:     config.src.app.client.dir
					scripts: config.src.app.client.scripts.dir
				dest:
					dir:     config.dist.app.client.dir
					scripts: config.dist.app.client.scripts.dir
				glob: config.glob.src.app.client.scripts.ts

			paths.tsconfig = path.join paths.src.dir, 'tsconfig.json'
			paths

	# API
	# ===
	api =
		runTask: (b, paths, opts) -> # bundle only
			fse.ensureDirSync paths.dest.scripts # needed for createWriteStream
			defer  = q.defer()
			bundle = b.bundle()
			bundle.on 'error', (e) -> log.task e.message, 'error'
			bundle.pipe fs.createWriteStream opts.bundle.path
			bundle.on 'end', ->
				defer.resolve message: "completed: run task"
			defer.promise

		runWatchTask: (b, paths, opts) -> # bundle then watch
			defer = q.defer()
			bundler = (watchPaths) ->
				b.bundle()
				.on 'error', (e) -> log.task e.message, 'error'
				.pipe source opts.bundle.fileName
				.pipe gulp.dest paths.dest.scripts
				.on 'end', ->
					return defer.resolve() unless watchPaths
					log.watchTS watchPaths
					defer.resolve message: "completed: run watch task"
			bundler()
			b.plugin(watchify, opts.watch).on 'update', bundler
			defer.promise

		init: ->
			isDev = config.env.is.dev
			_task = if isDev then 'runWatchTask' else 'runTask'
			paths = help.getPaths()
			opts  = help.getOpts paths
			b     = help.getBrowserify opts
			@[_task](b, paths, opts).then ->
				log.task 'watching client typescript files', 'minor' if isDev
				log: true
				message: "compiled typescript to: #{paths.dest.dir}"

	# return
	# ======
	api.init()




