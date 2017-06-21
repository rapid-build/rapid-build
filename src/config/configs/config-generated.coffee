module.exports = (config) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	hashHelp = require "#{config.req.helpers}/hash"
	test     = require("#{config.req.helpers}/test")()

	# helpers
	# =======
	join = (p1, p2) ->
		path.join p1, p2

	addHashToDir = (pkg) -> # update the reference, hash created from generated app path
		hash = hashHelp.getPathHash pkg.path
		for prop in ['dir', 'relPath', 'path']
			pkg[prop] += hash

	# init generated
	# ==============
	generated = {}
	generated.dir  = 'generated'
	generated.path = join config.rb.root, generated.dir
	generated.pkg  = {}
	generated.pkg.dir     = config.app.name
	generated.pkg.relPath = join generated.dir, generated.pkg.dir
	generated.pkg.path    = join generated.path, generated.pkg.dir
	addHashToDir generated.pkg # avoid naming collisions, ensure unique dir name
	generated.pkg.config  = join generated.pkg.path, 'config.json'
	generated.pkg.files   = {}
	generated.pkg.src     = {}
	generated.pkg.temp    = {}
	generated.pkg.files.dir                = 'files'
	generated.pkg.files.path               = join generated.pkg.path, generated.pkg.files.dir
	generated.pkg.files.files              = join generated.pkg.files.path, 'files.json'
	generated.pkg.files.testFiles          = join generated.pkg.files.path, 'test-files.json'
	generated.pkg.files.prodFiles          = join generated.pkg.files.path, 'prod-files.json'
	generated.pkg.files.prodFilesBlueprint = join generated.pkg.files.path, 'prod-files-blueprint.json'
	generated.pkg.src.dir  = 'src'
	generated.pkg.src.path = join generated.pkg.path, generated.pkg.src.dir
	generated.pkg.src.server = {}
	generated.pkg.src.server.path = join generated.pkg.src.path, 'server'
	generated.pkg.src.server.info = join generated.pkg.src.server.path, 'server-info.json'
	generated.pkg.src.server.pkg  = join generated.pkg.src.server.path, 'server.tgz'
	generated.pkg.temp.dir     = 'temp'
	generated.pkg.temp.relPath = join generated.pkg.relPath, generated.pkg.temp.dir
	generated.pkg.temp.path    = join generated.pkg.path, generated.pkg.temp.dir

	# add generated to config
	# =======================
	config.generated = generated

	# logs
	# ====
	# log.json generated, 'generated ='

	# tests
	# =====
	test.log 'true', config.generated, 'add generated to config'

	# return
	# ======
	config


