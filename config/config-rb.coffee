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
	rb.tasks.default        = 'rapid-build'
	rb.tasks.dev            = "#{rb.tasks.default}:dev"
	rb.tasks.test           = "#{rb.tasks.default}:test"
	rb.tasks.prod           = "#{rb.tasks.default}:prod"
	rb.tasks['prod:server'] = "#{rb.tasks.default}:prod:server"

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


