module.exports = (config, rbDir) ->
	fs   = require 'fs'
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()
	pkg  = require "#{config.req.rb}/package.json"

	# init rb
	# =======
	rb = {}
	rb.name    = pkg.name
	rb.version = pkg.version
	rb.dir     = rbDir

	# is symlink - determine if it has been installed via npm link
	# ==========
	getIsSymlink = ->
		dir       = path.join config.req.app, 'node_modules', rb.name
		isSymlink = fs.lstatSync(dir).isSymbolicLink()
		isSymlink

	rb.isSymlink = getIsSymlink()

	# api tasks
	# =========
	rb.tasks = {}
	rb.tasks.default             = rb.name
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
	rb.prefix.task    = pkg.tasksPrefix # prefix for all internal tasks
	rb.prefix.distDir = rb.name

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


