module.exports = (config, rbDir) ->
	# init req
	# ========
	req =
		rb:      rbDir
		app:     process.cwd()
		plugins: "#{rbDir}/plugins"
		helpers: "#{rbDir}/helpers"
		init:    "#{rbDir}/init"
		tasks:   "#{rbDir}/tasks"
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


