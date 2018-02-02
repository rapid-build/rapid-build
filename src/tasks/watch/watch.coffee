module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.env.is.dev

	# Requires
	# ========
	q           = require 'q'
	path        = require 'path'
	gWatch      = require 'gulp-watch'
	log         = require "#{config.req.helpers}/log"
	watchStore  = require("#{config.req.manage}/watch-store") config
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	# Tasks
	# =====
	Tasks =
		buildSpa: ->
			return promiseHelp.get() unless config.build.client
			taskManager.runWatchTask 'watch-build-spa'

		browserSync: ->
			return unless config.build.server
			taskManager.runWatchTask 'browser-sync', run: 'restart'

	# helpers
	# =======
	getAppOrRb = (file) ->
		return 'rb' if file.path.indexOf(config.src.rb.dir) isnt -1
		'app'

	getClientOrServer = (file) ->
		return 'client' if file.path
			.indexOf(config.src[file.rbAppOrRb].server.scripts.dir) is -1
		'server'

	getRelative = (file) ->
		dir = path.dirname file.relative
		return '' if dir is '.'
		dir

	getFileName = (file) ->
		fileName = path.basename file.path
		fileName

	getDistDir = (file, opts={}) ->
		dir = config.dist[file.rbAppOrRb][file.rbClientOrServer][opts.srcType].dir
		dir = path.join dir, file.rbRelative
		dir

	getDistPath = (file, opts={}) ->
		fileName = file.rbFileName
		if opts.extDist
			extSrc   = path.extname fileName
			fileName = fileName.replace extSrc, ".#{opts.extDist}"
		dPath = path.join file.rbDistDir, fileName
		dPath

	addFileProps = (file, opts={}) -> # must be in order
		file.rbAppOrRb        = getAppOrRb file
		file.rbClientOrServer = getClientOrServer file
		file.rbRelative       = getRelative file
		file.rbFileName       = getFileName file
		file.rbDistDir        = getDistDir file, opts
		file.rbDistPath       = getDistPath file, opts
		file.rbLog            = opts.logWatch if opts.addLog
		file

	# event tasks
	# ===========
	changeTask = (taskName, file, opts) ->
		Tasks.browserSync() if opts.bsReload is opts.event # see extra file watches
		taskManager.runWatchTask taskName, watchFile: file

	addTask = (taskName, file, opts) ->
		changeTask(taskName, file, opts).then ->
			return promiseHelp.get()   if opts.isTest
			return promiseHelp.get()   if opts.taskOnly
			return promiseHelp.get()   if opts.loc is 'server'
			return Tasks.browserSync() if opts.bsReload
			Tasks.buildSpa()

	cleanTask = (taskName, file, opts) ->
		return changeTask taskName, file, opts if opts.taskOnly
		taskManager.runWatchTask('clean-dist', watchFile: file).then ->
			return promiseHelp.get()   if opts.isTest
			return Tasks.browserSync() if opts.bsReload
			return opts.cleanCb(file).then(-> Tasks.buildSpa()) if opts.cleanCb
			Tasks.buildSpa()

	events = (file, taskName, opts={}) -> # add, change, unlink
		opts.logWatch = -> log.watch taskName, file, opts
		opts.logWatch() unless opts.silent
		return Tasks.buildSpa() if taskName is 'watch-build-spa'
		return unless file
		return unless file.event
		return unless file.path
		return unless taskName
		opts.event = file.event
		file = addFileProps file, opts
		switch file.event
			when 'add'    then addTask taskName, file, opts
			when 'change' then changeTask taskName, file, opts
			when 'unlink' then cleanTask taskName, file, opts

	# watches
	# =======
	createWatch = (taskName, glob, opts={}) ->
		defer = q.defer()
		gOpts = read: false
		gWatch glob, gOpts, (file) ->
			events file, taskName, opts
		.on 'ready', ->
			loc = opts.loc or 'client'
			loc = "#{loc} test" if opts.isTest
			msg = if opts.lang.indexOf('.') isnt -1 then 'file' else 'files'
			log.task "watching #{loc} #{opts.lang} #{msg}", 'minor'
			defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			watches = []
			Watches = watchStore.getWatches()

			for watchType, _watches of Watches # merge watches into single array
				continue unless _watches.length
				watches.push _watches...

			promises = watches.map (watch) ->
				createWatch watch.task, watch.glob, watch.opts

			q.all(promises).then ->
				# log: 'warn'
				message: "file watchers activated"
	# return
	# ======
	api.runTask()



