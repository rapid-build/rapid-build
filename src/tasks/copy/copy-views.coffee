module.exports = (config, gulp, Task) ->
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			if config.env.is.prod
				if config.minify.html.templateCache
					taskName = 'template-cache'
				else
					taskName = 'copy-html'
			else if config.angular.templateCache.dev
				taskName = 'template-cache'
			else
				taskName = 'copy-html'

			defer = q.defer()
			gulp.series([
				"#{config.rb.prefix.task}#{taskName}"
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()
