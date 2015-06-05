module.exports = (gulp, config) ->
	q      = require 'q'
	concat = require 'gulp-concat'

	runTask = (src, dest, file) ->
		defer = q.defer()
		gulp.src src
			.pipe concat file
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	runTasks = (loc, exclude) ->
		defer  = q.defer()
		client = require(config.json.files.path).client
		stylesExclude  = if not client.styles.length  then '' else exclude
		scriptsExclude = if not client.scripts.length then '' else exclude
		q.all([
			# styles
			runTask(
				client.styles.concat stylesExclude
				loc.styles.dir
				loc.styles.all.file
			)
			# scripts
			runTask(
				client.scripts.concat scriptsExclude
				loc.scripts.dir
				loc.scripts.all.file
			)
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}concat-app-files", ->
		runTasks(
			config.temp.client
			["!#{config.glob.dist.rb.client.libs.all}"
			 "!#{config.glob.dist.app.client.libs.all}"]
		)