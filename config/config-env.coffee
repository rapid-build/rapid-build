# ENV CONFIG
# Override technique is only used for build system testing.
# =========================================================
module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# constants
	# =========
	ENV_RB_MODE = process.env.RB_MODE

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
				env.is.default    = true
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
			when 'prod', 'prod:server'
				env.is.prod       = true
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
	env.name     = 'default'
	env.override = !!ENV_RB_MODE
	env.is =
		default:    true
		dev:        false
		prod:       false
		test:       false
		testClient: false
		testServer: false

	# add env to config
	# =================
	config.env = env

	# public methods
	# ==============
	config.env.set = (mode) -> # mode = build mode (called in 'set-env-config' which is called first in 'common')
		# console.log "OVERRIDE: #{config.env.override},".cyan, mode
		return unless mode
		config.env.name = mode
		setIsEnv()

	# env override
	# ============
	config.env.set ENV_RB_MODE if config.env.override

	# logs
	# ====
	# log.json config.env, 'env ='

	# tests
	# =====
	test.log 'true', config.env, 'add env to config'

	# return
	# ======
	config


