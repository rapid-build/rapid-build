module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}common", (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}update-config" # must be first and only called here
			"#{config.rb.prefix.task}bower"
			"#{config.rb.prefix.task}clean-dist"
			"#{config.rb.prefix.task}build-angular-modules"
			"#{config.rb.prefix.task}build-config"
			"#{config.rb.prefix.task}find-open-port" # updates config.ports if a port is in use
			[
				"#{config.rb.prefix.task}copy-bower_components"
				"#{config.rb.prefix.task}copy-css"
				"#{config.rb.prefix.task}copy-images"
				"#{config.rb.prefix.task}copy-js"
				"#{config.rb.prefix.task}copy-libs"
				"#{config.rb.prefix.task}copy-views"
				"#{config.rb.prefix.task}coffee"
				"#{config.rb.prefix.task}es6"
				"#{config.rb.prefix.task}less"
				"#{config.rb.prefix.task}sass"
				"#{config.rb.prefix.task}copy-server-config"
				"#{config.rb.prefix.task}copy-server-node_modules"
				"#{config.rb.prefix.task}compile-extra-coffee"
				"#{config.rb.prefix.task}compile-extra-es6"
				"#{config.rb.prefix.task}compile-extra-less"
				"#{config.rb.prefix.task}compile-extra-sass"
				"#{config.rb.prefix.task}copy-extra-files"
			]
			"#{config.rb.prefix.task}absolute-css-urls"
			"#{config.rb.prefix.task}build-files"
			cb
		)

