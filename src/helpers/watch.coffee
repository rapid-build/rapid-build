# WATCH HELPER
# introduced for chokidar
# =======================
module.exports = (config) ->
	path     = require 'path'
	pathHelp = require "#{config.req.helpers}/path"

	# API
	# ===
	getOptions: (opts={}) -> # chokidar options
		watchOpts = ignoreInitial: true
		return watchOpts unless Object.keys(opts).length
		return watchOpts unless process.platform is 'win32'
		return watchOpts unless opts.task and opts.delayTasks
		# for windows when watching extra files
		delayTask = opts.delayTasks.every (task) ->
			opts.task.indexOf(task) isnt -1
		return watchOpts unless delayTask
		watchOpts.awaitWriteFinish = stabilityThreshold: 600
		watchOpts

	getGlobs: (glob, opts={}) ->
		globs =
			task:      opts.task
			files:     []
			paths:     []
			globstars: []

		delete globs.task unless opts.task
		return globs if !glob or !glob.length

		for val in glob
			continue if val.indexOf('!') isnt -1 # remove ignores
			if val.endsWith '/' # absolute paths
				globs.paths.push val
				continue
			if val.indexOf('*') isnt -1
				globs.globstars.push val
				continue
			globs.files.push val # file paths
		globs

	getFileInfo: (_event, _path, globs) ->
		_path    = pathHelp.format _path
		filename = path.basename _path
		extname  = path.extname filename
		cwd      = pathHelp.format process.cwd()
		base     = @_getBasepath _path, globs
		relative = path.relative base, _path
		relative = pathHelp.format relative
		file = {
			event: _event
			extname
			filename
			cwd
			base
			path: _path
			relative
		}

	_getBasepath: (_path, globs) ->
		basepath = @_getFileBase _path, globs.files
		return basepath if basepath # files check

		basepath = @_getPathBase _path, globs.paths
		return basepath if basepath # absolute paths check

		basepath = @_getGlobstarBase _path, globs.globstars
		return basepath # globstar check

	_getFileBase: (_path, globs) ->
		basepath = globs.find (val) ->
			return val.indexOf(_path) isnt -1
		return unless basepath
		path.dirname basepath

	_getPathBase: (_path, globs) ->
		for val in globs
			if _path.indexOf(val) isnt -1
				# remove trailing slash
				basepath = val.substr 0, val.length - 1
				break
		basepath

	_getGlobstarBase: (_path, globs) ->
		for val in globs
			val = val.split('/*')[0] # where a glob starts
			if _path.indexOf(val) isnt -1
				basepath = val; break
		basepath
