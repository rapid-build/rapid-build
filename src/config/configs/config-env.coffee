# ENV CONFIG
# Override technique is only used for build system testing.
# =========================================================
module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# constants
	# =========
	RB_MODE_OVERRIDE = process.env.RB_MODE_OVERRIDE

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
				env.is.testBoth   = true
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
				env.is.testBoth   = true
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
				env.is.prodServer = true if name is 'prod:server'
			when 'prod:test'
				env.is.prod       = true
				env.is.test       = true
				env.is.testBoth   = true
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

	prepMode = (mode) ->
		return mode unless mode
		return mode if mode.indexOf(config.rb.prefix.api) is -1
		mode = mode.split(':').slice(1).join(':')

	# init env
	# ========
	env = {}
	env.name     = 'default'
	env.override = !!RB_MODE_OVERRIDE
	env.is =
		default:    true
		dev:        false
		prod:       false
		test:       false
		testBoth:   false
		testClient: false
		testServer: false
		prodServer: false

	# add env to config
	# =================
	config.env = env

	# public methods
	# ==============
	config.env.set = (mode, force = false) -> # mode = build mode (called in 'set-env-config' which is called first in 'common')
		return unless mode
		return if not force and config.env.override
		# log.task "OVERRIDE: #{config.env.override}", 'warn'
		mode = prepMode mode
		# log.task "IF OVERRIDE: use override build \"#{mode}\"", 'warn'
		return unless mode
		config.env.name = mode
		setIsEnv()

	# env override
	# ============
	config.env.set RB_MODE_OVERRIDE, true if config.env.override

	# logs
	# ====
	# log.json config.env, 'env ='

	# tests
	# =====
	test.log 'true', config.env, 'add env to config'

	# return
	# ======
	config


