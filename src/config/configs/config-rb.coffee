module.exports = (config, rbDir) ->
	fs       = require 'fs'
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	test     = require("#{config.req.helpers}/test")()
	rootPath = path.resolve config.req.rb, '..'
	pkg      = require "#{rootPath}/package.json"

	# init rb
	# =======
	rb = {}
	rb.name    = pkg.name
	rb.version = pkg.version
	rb.root    = rootPath
	rb.dir     = rbDir

	# is symlink - determine if it has been installed via npm link
	# ==========
	getIsSymlink = ->
		dir = path.join config.req.app, 'node_modules', rb.name
		try
			isSymlink = fs.lstatSync(dir).isSymbolicLink()
		catch e # globally installed
			isSymlink = false

	rb.isSymlink = getIsSymlink()

	# prefixes
	# ========
	rb.prefix = {}
	rb.prefix.api     = rb.name
	rb.prefix.task    = pkg.build.tasksPrefix # prefix for all internal tasks
	rb.prefix.distDir = rb.name

	# api tasks
	# =========
	rb.tasks = {}
	rb.tasks.default             = rb.prefix.api
	rb.tasks.test                = "#{rb.prefix.api}:test"
	rb.tasks['test:client']      = "#{rb.prefix.api}:test:client"
	rb.tasks['test:server']      = "#{rb.prefix.api}:test:server"
	rb.tasks.dev                 = "#{rb.prefix.api}:dev"
	rb.tasks['dev:test']         = "#{rb.prefix.api}:dev:test"
	rb.tasks['dev:test:client']  = "#{rb.prefix.api}:dev:test:client"
	rb.tasks['dev:test:server']  = "#{rb.prefix.api}:dev:test:server"
	rb.tasks.prod                = "#{rb.prefix.api}:prod"
	rb.tasks['prod:server']      = "#{rb.prefix.api}:prod:server"
	rb.tasks['prod:test']        = "#{rb.prefix.api}:prod:test"
	rb.tasks['prod:test:client'] = "#{rb.prefix.api}:prod:test:client"
	rb.tasks['prod:test:server'] = "#{rb.prefix.api}:prod:test:server"

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


