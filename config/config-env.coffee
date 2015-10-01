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
			when 'test'
				env.is.default    = true
				env.is.test       = true
				env.is.testClient = true
				env.is.testServer = true
			when 'test:client'
				env.is.default    = true
				env.is.test       = true
				env.is.testClient = true
			when 'test:server'
				env.is.default    = true
				env.is.test       = true
				env.is.testServer = true
			when 'dev'
				env.is.dev = true
			when 'dev:test'
				env.is.dev        = true
				env.is.test       = true
				env.is.testClient = true
				env.is.testServer = true
			when 'dev:test:client'
				env.is.dev        = true
				env.is.test       = true
				env.is.testClient = true
			when 'dev:test:server'
				env.is.dev        = true
				env.is.test       = true
				env.is.testServer = true
			when 'prod'
				env.is.prod = true
			when 'prod:test'
				env.is.prod       = true
				env.is.test       = true
				env.is.testClient = true
				env.is.testServer = true
			when 'prod:test:client'
				env.is.prod       = true
				env.is.test       = true
				env.is.testClient = true
			when 'prod:test:server'
				env.is.prod       = true
				env.is.test       = true
				env.is.testServer = true

	# init env
	# ========
	env = {}
	env.name = 'default'

	# is
	# ==
	env.is =
		default: true
		dev:  false
		prod: false
		test: false
		testClient: false
		testServer: false

	# methods
	# =======
	env.set = (taskSeqs) -> # called in 'set-env-config' which is called first in 'common'
		switch taskSeqs[2]
			when config.rb.tasks.test then config.env.name = 'test'
			when config.rb.tasks['test:client'] then config.env.name = 'test:client'
			when config.rb.tasks['test:server'] then config.env.name = 'test:server'
			when config.rb.tasks.dev then config.env.name = 'dev'
			when config.rb.tasks['dev:test'] then config.env.name = 'dev:test'
			when config.rb.tasks['dev:test:client'] then config.env.name = 'dev:test:client'
			when config.rb.tasks['dev:test:server'] then config.env.name = 'dev:test:server'
			when config.rb.tasks.prod then config.env.name = 'prod'
			when config.rb.tasks['prod:test'] then config.env.name = 'prod:test'
			when config.rb.tasks['prod:test:client'] then config.env.name = 'prod:test:client'
			when config.rb.tasks['prod:test:server'] then config.env.name = 'prod:test:server'

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


