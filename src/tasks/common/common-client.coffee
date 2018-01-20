module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.client
			gulp.series([
				"#{config.rb.prefix.task}update-angular-mocks-config"
				"#{config.rb.prefix.task}build-bower-json"
				"#{config.rb.prefix.task}bower"
				"#{config.rb.prefix.task}build-angular-modules"
				"#{config.rb.prefix.task}build-angular-bootstrap"
				gulp.parallel([
					"#{config.rb.prefix.task}copy-bower_components"
					"#{config.rb.prefix.task}copy-css"
					"#{config.rb.prefix.task}copy-images"
					"#{config.rb.prefix.task}copy-js:client"
					"#{config.rb.prefix.task}copy-libs"
					"#{config.rb.prefix.task}copy-views"
					"#{config.rb.prefix.task}coffee:client"
					"#{config.rb.prefix.task}es6:client"
					"#{config.rb.prefix.task}typescript:client"
					"#{config.rb.prefix.task}less"
					"#{config.rb.prefix.task}sass"
					"#{config.rb.prefix.task}compile-extra-coffee:client"
					"#{config.rb.prefix.task}compile-extra-es6:client"
					"#{config.rb.prefix.task}compile-extra-html-scripts:client"
					"#{config.rb.prefix.task}compile-extra-less:client"
					"#{config.rb.prefix.task}compile-extra-sass:client"
					"#{config.rb.prefix.task}copy-extra-files:client"
				])
				"#{config.rb.prefix.task}update-css-urls"
				"#{config.rb.prefix.task}clean-rb-client" # if exclude.default.client.files
				"#{config.rb.prefix.task}build-files"
				"#{config.rb.prefix.task}build-spa:dev"
				"#{config.rb.prefix.task}inline-html-assets:dev"
				"#{config.rb.prefix.task}inline-js-html-imports:dev"
				(cb) -> cb(); taskOpts.taskCB()
			])()
	# return
	# ======
	api.runTask()

