# todo: move all templates to here
# ================================
module.exports = (config) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# helpers
	# =======
	getInfo = (srcFile, destFile, destDir) ->
		src:
			path: path.join templates.dir, srcFile
		dest:
			file: destFile
			dir:  destDir
			path: path.join destDir, destFile

	# init templates
	# ==============
	templates = {}
	templates.dir = path.join config.rb.dir, 'templates'

	# set templates info
	# ==================
	templates.angularModules = getInfo(
		'angular-modules.tpl'
		'app.coffee'
		config.src.rb.client.scripts.dir
	)

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


