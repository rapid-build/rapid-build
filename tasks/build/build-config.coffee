module.exports = (gulp, config) ->
	configHelp = require("#{config.req.helpers}/config") config

	runTask = ->
		configHelp.buildFile true

	# task deps
	# =========
	taskDeps = ["#{config.rb.prefix.task}clean-config"]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-config", taskDeps, ->
		runTask()