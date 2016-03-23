# build env helper
# see config-build
# ================
module.exports =
	is:
		default:    false
		dev:        false
		prod:       false
		test:       false
		testClient: false
		testServer: false

	get: (mode) ->
		switch mode
			when 'default'
				@is.default    = true
			when 'test'
				@is.default    = true
				@is.test       = true
				@is.testClient = true
				@is.testServer = true
			when 'test:client'
				@is.default    = true
				@is.test       = true
				@is.testClient = true
			when 'test:server'
				@is.default    = true
				@is.test       = true
				@is.testServer = true
			when 'dev'
				@is.dev = true
			when 'dev:test'
				@is.dev        = true
				@is.test       = true
				@is.testClient = true
				@is.testServer = true
			when 'dev:test:client'
				@is.dev        = true
				@is.test       = true
				@is.testClient = true
			when 'dev:test:server'
				@is.dev        = true
				@is.test       = true
				@is.testServer = true
			when 'prod', 'prod:server'
				@is.prod       = true
			when 'prod:test'
				@is.prod       = true
				@is.test       = true
				@is.testClient = true
				@is.testServer = true
			when 'prod:test:client'
				@is.prod       = true
				@is.test       = true
				@is.testClient = true
			when 'prod:test:server'
				@is.prod       = true
				@is.test       = true
				@is.testServer = true
			else
				@is.default    = true

		@is



