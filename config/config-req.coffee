module.exports = (config, rbDir) ->
	# init req
	# ========
	req =
		rb:      rbDir
		app:     process.cwd()
		config:  "#{rbDir}/config"
		files:   "#{rbDir}/files"
		helpers: "#{rbDir}/helpers"
		init:    "#{rbDir}/init"
		tasks:   "#{rbDir}/tasks"

	# add req to config
	# =================
	config.req = req

	# logs
	# ====
	# console.log req, 'req ='

	# return
	# ======
	config


