# Task is only called from the common task.
# =========================================
module.exports = (gulp, config) ->
	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}set-env-config", ->
		config.env.set gulp.seq