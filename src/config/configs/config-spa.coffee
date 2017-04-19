module.exports = (config, options) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	pkg      = require "#{config.req.app}/package.json"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# helpers
	# =======
	getSrcFilePath = (_isCustom, _path) ->
		rbDir  = config.src.rb.client.dir
		appDir = config.src.app.client.dir
		return path.join rbDir, 'spa.html' unless _isCustom
		_path  = pathHelp.format _path
		_path  = "/#{_path}" if _path[0] isnt '/'
		_path  = path.join appDir, _path
		_path

	# defaults
	# ========
	customSrcPath   = options.spa.src.filePath
	isCustom        = !!customSrcPath
	srcFilePath     = getSrcFilePath isCustom, customSrcPath
	srcFile         = path.basename srcFilePath
	srcDir          = path.dirname srcFilePath
	distFile        = options.spa.dist.fileName or srcFile
	distFilePath    = path.join config.dist.app.client.dir, distFile
	distFileAbsPath = path.join config.app.dir, distFilePath
	tempFilePath    = path.join config.generated.pkg.temp.path, distFilePath

	# init spa
	# ========
	spa = {}
	spa.custom = isCustom

	# autoInject
	# ==========
	spa.autoInject = if options.spa.autoInject is null then ['all'] else options.spa.autoInject

	# placeholders
	# ============
	spa.title       = options.spa.title or config.app.name or 'Application'
	spa.description = options.spa.description or pkg.description or null

	# dist
	# ====
	spa.dist =
		file:    distFile
		path:    distFilePath
		absPath: distFileAbsPath

	# src
	# ===
	spa.src =
		file: srcFile
		dir:  srcDir
		path: srcFilePath

	# temp
	# ====
	spa.temp =
		path: tempFilePath

	# placeholders
	# ============
	spa.placeholders = options.spa.placeholders or []

	# scripts and styles
	# ==================
	spa.scripts =
		attrs: options.spa.scripts.attrs or null

	spa.styles =
		attrs: options.spa.styles.attrs or null

	# add spa to config
	# =================
	config.spa = spa

	# logs
	# ====
	# log.json spa, 'spa ='

	# tests
	# =====
	test.log 'true', config.spa, 'add spa to config'

	# return
	# ======
	config


