# for watch events: add and unlink
# ================================
module.exports = (config, gulp, Task) ->
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			gulp.series([
				"#{config.rb.prefix.task}build-files"
				"#{config.rb.prefix.task}build-spa:dev"
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()

