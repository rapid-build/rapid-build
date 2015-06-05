module.exports = (gulp, config) ->
	# task deps
	# =========
	taskDeps = ["#{config.rb.prefix.task}nodemon"]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}start-server", taskDeps

