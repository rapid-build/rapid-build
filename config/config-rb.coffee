module.exports = (config, rbDir) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()
	pkg  = require "#{config.req.rb}/package.json"

	# init rb
	# =======
	rb = {}
	rb.name    = pkg.name
	rb.version = pkg.version
	rb.dir     = rbDir

	# api tasks
	# =========
	rb.tasks = {}
	rb.tasks.default             = 'rapid-build'
	rb.tasks.test                = "#{rb.tasks.default}:test"
	rb.tasks['test:client']      = "#{rb.tasks.default}:test:client"
	rb.tasks['test:server']      = "#{rb.tasks.default}:test:server"
	rb.tasks.dev                 = "#{rb.tasks.default}:dev"
	rb.tasks['dev:test']         = "#{rb.tasks.default}:dev:test"
	rb.tasks['dev:test:client']  = "#{rb.tasks.default}:dev:test:client"
	rb.tasks['dev:test:server']  = "#{rb.tasks.default}:dev:test:server"
	rb.tasks.prod                = "#{rb.tasks.default}:prod"
	rb.tasks['prod:server']      = "#{rb.tasks.default}:prod:server"
	rb.tasks['prod:test']        = "#{rb.tasks.default}:prod:test"
	rb.tasks['prod:test:client'] = "#{rb.tasks.default}:prod:test:client"
	rb.tasks['prod:test:server'] = "#{rb.tasks.default}:prod:test:server"

	# prefixes
	# ========
	rb.prefix = {}
	rb.prefix.task    = 'rb-' # prefix for all internal tasks
	rb.prefix.distDir = 'rapid-build'

	# add rb to config
	# ================
	config.rb = rb

	# logs
	# ====
	# log.json rb, 'rb ='

	# tests
	# =====
	test.log 'true', config.rb, 'add rb to config'

	# return
	# ======
	config


