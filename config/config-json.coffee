module.exports = (config) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init json
	# =========
	json = {}
	json.bower  = {}
	json.config = {}
	json.files  = {}

	# json bower
	# ==========
	json.bower = {}
	json.bower.file = 'bower.json'
	json.bower.dir  = config.rb.dir
	json.bower.path = path.join json.bower.dir, json.bower.file

	# json config
	# ===========
	json.config = {}
	json.config.file     = 'config.json'
	json.config.dir      = path.join config.rb.dir, 'config'
	json.config.path     = path.join json.config.dir, json.config.file
	json.config.template = path.join json.config.dir, 'config.tpl'

	# json files
	# ==========
	json.files = {}
	json.files.file     = 'files.json'
	json.files.dir      = path.join config.rb.dir, 'files'
	json.files.path     = path.join json.files.dir, json.files.file
	json.files.template = path.join json.files.dir, 'files.tpl'

	# add json to config
	# ==================
	config.json = json

	# logs
	# ====
	# log.json json, 'json ='

	# tests
	# =====
	test.log 'true', config.json, 'add json to config'

	# return
	# ======
	config


