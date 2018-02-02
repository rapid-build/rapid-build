module.exports = (config, rbDir) ->
	# init req
	# ========
	req =
		rb:      rbDir
		app:     process.cwd()
		helpers: "#{rbDir}/helpers"
		init:    "#{rbDir}/init"
		manage:  "#{rbDir}/manage"
		plugins: "#{rbDir}/plugins"
		tasks:   "#{rbDir}/tasks"
		watches: "#{rbDir}/watches"
		config:
			path:    "#{rbDir}/config"
			configs: "#{rbDir}/config/configs"
			options: "#{rbDir}/config/options"

	# add req to config
	# =================
	config.req = req

	# logs
	# ====
	# console.log req, 'req ='

	# return
	# ======
	config


