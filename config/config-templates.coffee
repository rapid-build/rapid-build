# todo: move all templates to here
# ================================
module.exports = (config) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init templates
	# ==============
	templates = {}
	templates.dir = path.join config.rb.dir, 'templates'
	templates.angularModules =
		src:
			path: path.join templates.dir, 'angular-modules.tpl'
		dest:
			file: 'app.coffee'
			dir:  path.join config.src.rb.client.scripts.dir

	# add templates to config
	# =======================
	config.templates = templates

	# logs
	# ====
	# log.json templates, 'templates ='

	# tests
	# =====
	test.log 'true', config.templates, 'add templates to config'

	# return
	# ======
	config


