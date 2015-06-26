module.exports = (config, options) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# rb angular files in order
	# =========================
	angularFiles = [
		'angular.js'
		'angular-mocks.js'
		'angular-resource.js'
		'angular-route.js'
		'angular-sanitize.js'
	]

	# helpers
	# =======
	getDirName = (appOrRb, type) ->
		dir = pathHelp.format config.dist[appOrRb].client[type].dir
		i   = dir.lastIndexOf('/') + 1
		dir.substr i

	getAngularFiles = ->
		_paths = []
		angularFiles.forEach (file, i) ->
			_paths.push "#{rb.bower}/#{file}"
		_paths

	# defaults
	# ========
	rb =
		bower:   config.dist.rb.client.bower.dirName
		libs:    config.dist.rb.client.libs.dirName
		scripts: getDirName 'rb', 'scripts'
		styles:  getDirName 'rb', 'styles'

	rb.files =
		rb: ["#{rb.scripts}/app.js"]
		angular: getAngularFiles()

	# init order
	# =========
	order =
		rb:
			scripts: first: [], last: []
			styles:  first: [], last: []
		app:
			scripts:
				first: options.order.scripts.first or [],
				last:  options.order.scripts.last  or []
			styles:
				first: options.order.styles.first or [],
				last:  options.order.styles.last  or []

	# rb order
	# ========
	files = []
	files = files.concat rb.files.angular if not options.angular.exclude.files
	order.rb.scripts.first = files.concat rb.files.rb

	# methods
	# =======
	removeRbAngularMocks = -> # helper
		order.rb.scripts.first.splice 1, 1

	order.removeRbAngularMocks = ->
		if config.env.is.prod
			removeRbAngularMocks() if not config.angular.httpBackend.prod
		else if not config.angular.httpBackend.dev
			removeRbAngularMocks()

	# process order
	# =============
	removeExts = ->
		for own k1, v1 of order
			for own k2, v2 of v1
				for own k3, v3 of v2
					continue if not v3.length
					v3.forEach (v4, i) ->
						ext   = path.extname v4
						v3[i] = v3[i].replace ext, '' if ext isnt '.min'

	removeExts()

	# add order to config
	# ===================
	config.order = order

	# logs
	# ====
	# log.json order, 'order ='

	# tests
	# =====
	test.log 'true', config.order, 'add order to config'

	# return
	# ======
	config



