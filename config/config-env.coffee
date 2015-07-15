module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# helpers
	# =======
	resetIsEnv = ->
		for own k, v of env.is
			env.is[k] = false

	setIsEnv = ->
		resetIsEnv()
		name = config.env.name
		switch name
			when 'default'
				env.is.default = true
				env.is.defaultOrDev = true
			when 'dev'
				env.is.dev = true
				env.is.defaultOrDev = true
			when 'prod'
				env.is.prod = true
			when 'test'
				env.is.test = true

	# init env
	# ========
	env = {}
	env.name = 'default'

	# is
	# ==
	env.is =
		default: true
		defaultOrDev: true
		dev: false
		prod: false
		test: false

	# methods
	# =======
	env.set = (gulp) ->
		switch gulp.seq[2] # called in 'rb-update-config' which is called first in 'rb-common'
			when config.rb.tasks.dev  then config.env.name = 'dev'
			when config.rb.tasks.prod then config.env.name = 'prod'
			when config.rb.tasks.test then config.env.name = 'test'
		setIsEnv()

	# add env to config
	# =================
	config.env = env

	# logs
	# ====
	# log.json env, 'env ='

	# tests
	# =====
	test.log 'true', config.env, 'add env to config'

	# return
	# ======
	config


