module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			gulp.series([
				"#{config.rb.prefix.task}find-open-port"
				gulp.parallel([
					"#{config.rb.prefix.task}copy-js:server"
					"#{config.rb.prefix.task}coffee:server"
					"#{config.rb.prefix.task}es6:server"
					"#{config.rb.prefix.task}typescript:server"
					"#{config.rb.prefix.task}copy-server-config"
					"#{config.rb.prefix.task}copy-server-info"
					"#{config.rb.prefix.task}copy-server-node_modules"
					"#{config.rb.prefix.task}copy-server-pkgs"
					"#{config.rb.prefix.task}compile-extra-less:server"
					"#{config.rb.prefix.task}compile-extra-sass:server"
					"#{config.rb.prefix.task}copy-extra-files:server"
				])
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

