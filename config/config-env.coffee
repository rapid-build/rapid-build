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
				env.is.testClient = true
				env.is.testServer = true
			when 'test:prod'
				env.is.prod = true
				env.is.testClient = true
				env.is.testServer = true
			when 'test:client'
				env.is.testClient = true
			when 'test:client:prod'
				env.is.prod = true
				env.is.testClient = true
			when 'test:server'
				env.is.testServer = true
			when 'test:server:prod'
				env.is.prod = true
				env.is.testServer = true

	# init env
	# ========
	env = {}
	env.name = 'default'

	# is
	# ==
	env.is =
		default: true
		defaultOrDev: true
		dev:  false
		prod: false
		testClient: false
		testServer: false

	# methods
	# =======
	env.set = (taskSeqs) -> # called in 'set-env-config' which is called first in 'common'
		switch taskSeqs[2]
			when config.rb.tasks.dev  then config.env.name = 'dev'
			when config.rb.tasks.prod then config.env.name = 'prod'
			when config.rb.tasks.test then config.env.name = 'test'
			when config.rb.tasks['test:prod']   then config.env.name = 'test:prod'
			when config.rb.tasks['test:client'] then config.env.name = 'test:client'
			when config.rb.tasks['test:server'] then config.env.name = 'test:server'
			when config.rb.tasks['test:client:prod'] then config.env.name = 'test:client:prod'
			when config.rb.tasks['test:server:prod'] then config.env.name = 'test:server:prod'

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


