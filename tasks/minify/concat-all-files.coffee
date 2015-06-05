module.exports = (gulp, config) ->
	q      = require 'q'
	concat = require 'gulp-concat'

	runTask = (src, dest, file, type) ->
		defer = q.defer()
		gulp.src src
			.pipe concat file
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "prepended #{type} libs to #{file}".yellow
				defer.resolve()
		defer.promise

	runTasks = (loc, exclude) ->
		defer  = q.defer()
		client = require(config.json.files.path).client
		q.all([
			# styles
			runTask(
				client.styles.concat(
					loc.styles.min.path
					"!#{config.glob.dist.rb.client.styles.all}"
			 		"!#{config.glob.dist.app.client.styles.all}"
				)
				loc.styles.dir
				loc.styles.min.file
				'style'
			)
			# scripts
			runTask(
				client.scripts.concat(
					loc.scripts.min.path
					"!#{config.glob.dist.rb.client.scripts.all}"
			 		"!#{config.glob.dist.app.client.scripts.all}"
				)
				loc.scripts.dir
				loc.scripts.min.file
				'script'
			)
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}concat-all-files", ->
		runTasks config.temp.client


