module.exports = (config, gulp, taskOpts={}) ->
	q           = require 'q'
	path        = require 'path'
	browserify  = require 'browserify'
	tsify       = require 'tsify'
	watchify    = require 'watchify'
	source      = require 'vinyl-source-stream'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# helpers
	# =======
	help =
		getOpts: (paths) ->
			b:
				basedir: paths.src.scripts
				entries: config.compile.typescript.client.entries
				cache:   {}
				packageCache: {}
			ts:
				project: paths.tsconfig
			watch:
				ignoreWatch: ['**/node_modules/**']
			bundle:
				fileName: 'bundle.js' # todo build option

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

	# tasks
	# =====
	runTask = (paths, opts) ->
		defer = q.defer()
		b     = browserify(opts.b).plugin tsify, opts.ts

		bundle = (watchPaths) ->
			b.bundle()
			.on 'error', (e) ->
				log.task e.message, 'error'
			.pipe source opts.bundle.fileName
			.pipe gulp.dest paths.dest.scripts
			.on 'end', ->
				return defer.resolve() unless watchPaths
				log.watchTS watchPaths

		bundle() # init bundle

		if config.env.is.dev # create watch
			b.plugin(watchify, opts.watch).on 'update', bundle
			log.task 'watching client typescript files', 'minor'

		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.compile.typescript.client.enable
			paths   = help.getPaths()
			opts    = help.getOpts paths
			promise = runTask paths, opts
			promise.done ->
				log.task "compiled typescript to: #{paths.dest.dir}"
			promise

	# return
	# ======
	api.runTask()




