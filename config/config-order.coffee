module.exports = (config, options) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# helpers
	# =======
	getDirName = (appOrRb, type) ->
		dir = pathHelp.format config.dist[appOrRb].client[type].dir
		i   = dir.lastIndexOf('/') + 1
		dir.substr i

	# defaults
	# ========
	rb =
		libs:    config.dist.rb.client.libs.dirName
		scripts: getDirName 'rb', 'scripts'
		styles:  getDirName 'rb', 'styles'

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
	order.rb.scripts.first = [
		"#{rb.libs}/angular"
		"#{rb.libs}/angular-animate"
		"#{rb.libs}/angular-resource"
		"#{rb.libs}/angular-route"
		"#{rb.libs}/angular-sanitize"
		"#{rb.scripts}/app"
	]

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



