module.exports = (config, gulp, taskOpts={}) ->
	gulpSequence = require('gulp-sequence').use gulp

	# API
	# ===
	api =
		runTask: (cb) ->
			if config.env.is.prod
				if config.minify.html.templateCache
					task = 'template-cache'
				else
					task = 'copy-html'
			else if config.angular.templateCache.dev
				task = 'template-cache'
			else
				task = 'copy-html'

			gulpSequence "#{config.rb.prefix.task}#{task}", cb

	# return
	# ======
	api.runTask taskOpts.taskCB
