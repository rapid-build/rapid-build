module.exports = (config, gulp, taskOpts={}) ->
	# API
	# ===
	api =
		runTask: ->
			if config.env.is.prod
				if config.minify.html.templateCache
					task = 'template-cache'
				else
					task = 'copy-html'
			else if config.angular.templateCache.dev
				task = 'template-cache'
			else
				task = 'copy-html'

			gulp.series([
				"#{config.rb.prefix.task}#{task}"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()
