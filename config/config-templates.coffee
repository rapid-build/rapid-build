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

	# angular modules
	# ===============
	templates.angularModules =
		src:
			path: path.join templates.dir, 'angular-modules.tpl'
		dest:
			file: 'app.coffee'
			dir:  config.src.rb.client.scripts.dir

	# bower.json
	# ==========
	templates.bowerJson =
		src:
			path: path.join templates.dir, 'bower-json.tpl'
		dest:
			file: 'bower.json'
			dir:  config.rb.dir

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


