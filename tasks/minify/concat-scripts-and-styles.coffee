module.exports = (gulp, config) ->
	q      = require 'q'
	path   = require 'path'
	concat = require 'gulp-concat'
	log    = require "#{config.req.helpers}/log"

	# order helpers
	# =============
	getGlob = (appOrRb, type, glob) ->
		switch type
			when 'scripts' then lang = 'js'
			when 'styles'  then lang = 'css'
		globs =
			app:     config.glob.dist[appOrRb].client[type].all
			bower:   config.glob.dist[appOrRb].client.bower[lang]
			libs:    config.glob.dist[appOrRb].client.libs[lang]
			first:   config.order[appOrRb][type].first
			last:    config.order[appOrRb][type].last
			exclude: config.exclude[appOrRb].from.spaFile[type]
		globs[glob]

	getGlobs = (appOrRb, type, _globs) ->
		globs = []
		return globs if not _globs
		_globs.forEach (v) ->
			globs = globs.concat getGlob appOrRb, type, v
		globs

	getIncludes = (appOrRb, type, globs) ->
		getGlobs appOrRb, type, globs

	getExcludes = (appOrRb, type, globs) ->
		globs = getGlobs appOrRb, type, globs
		return globs if not globs.length
		globs.forEach (glob, i) ->
			globs[i] = "!#{glob}" if glob[0] isnt '!' # spa exclude already has '!'
		globs

	concatGlobs = (appOrRb, type, includes, excludes) ->
		[].concat getIncludes appOrRb, type, includes
		  .concat getExcludes appOrRb, type, excludes

	getSrc = (appOrRb, type) ->
		src =
			first:  concatGlobs appOrRb, type, ['first']
			second: concatGlobs appOrRb, type, ['bower'], ['first', 'last', 'exclude']
			third:  concatGlobs appOrRb, type, ['libs'],  ['first', 'last', 'exclude']
			middle: concatGlobs appOrRb, type, ['app'],   ['first', 'last', 'exclude']
			last:   concatGlobs appOrRb, type, ['last']

	# load order tasks
	# ================
	runOrderTask = (src, dest, file, appOrRb, type) ->
		switch type # only for logging
			when 'scripts' then type = 'script'
			when 'styles'  then type = 'style'
		defer = q.defer()
		gulp.src src
			.pipe concat file
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "created #{appOrRb} #{type} #{file}".yellow
				defer.resolve()
		defer.promise

	runOrderTasks = (appOrRb, type) ->
		defer = q.defer()
		dest  = config.temp.client[type][appOrRb].dir
		src   = getSrc appOrRb, type
		q.all([
			runOrderTask src.first,  dest, config.fileName[type].load.first,  appOrRb, type
			runOrderTask src.second, dest, config.fileName[type].load.second, appOrRb, type
			runOrderTask src.third,  dest, config.fileName[type].load.third,  appOrRb, type
			runOrderTask src.middle, dest, config.fileName[type].load.middle, appOrRb, type
			runOrderTask src.last,   dest, config.fileName[type].load.last,   appOrRb, type
		]).done -> defer.resolve()
		defer.promise

	runMultiOrderTask = ->
		defer = q.defer()
		q.all([
			runOrderTasks 'rb',  'scripts'
			runOrderTasks 'app', 'scripts'
			runOrderTasks 'rb',  'styles'
			runOrderTasks 'app', 'styles'
		]).done -> defer.resolve()
		defer.promise

	# min helpers
	# ===========
	getLoadingGlob = (type) ->
		glob = []
		['rb', 'app'].forEach (appOrRb) ->
			for own k, file of config.fileName[type].load
				_path = path.join config.temp.client[type][appOrRb].dir, file
				glob.push _path
		glob

	# min tasks
	# =========
	runMinTask = (type) ->
		defer = q.defer()
		src   = getLoadingGlob type
		file  = config.temp.client[type].min.file
		dest  = config.temp.client[type].dir
		gulp.src src
			.pipe concat file
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	runMultiMinTask = ->
		defer = q.defer()
		q.all([
			runMinTask 'scripts'
			runMinTask 'styles'
		]).done -> defer.resolve()
		defer.promise

	runScriptsAndStylesTask = -> # synchronously
		defer = q.defer()
		tasks = [
			-> runMultiOrderTask()
			-> runMultiMinTask()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}concat-scripts-and-styles", ->
		runScriptsAndStylesTask()





