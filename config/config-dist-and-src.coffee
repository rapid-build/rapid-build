module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"

	# defaults
	# ========
	dir =
		dist:    'dist'
		src:     'src'
		client:  'client'
		images:  'images'
		bower:   'bower_components'
		libs:    'libs'
		server:  'server'
		scripts: 'scripts'
		styles:  'styles'
		test:    'test'
		views:   'views'

	file =
		appServer: 'routes.js' # app server dist entry file
		rbServer:  'server.js' # rb server dist bootstrap file

	# dirs
	# ====
	getDirs = (loc, isApp) ->
		o = {}

		switch loc
			when 'dist'
				o.dir       = options[loc].dir
				o.clientDir = options[loc].client.dir
				o.serverDir = options[loc].server.dir
			when 'src'
				o.clientDir = options[loc].client.dir if isApp

		if isApp
			o.clientBower   = options[loc].client.bower.dir
			o.clientImages  = options[loc].client.images.dir
			o.clientLibs    = options[loc].client.libs.dir
			o.clientScripts = options[loc].client.scripts.dir
			o.clientStyles  = options[loc].client.styles.dir
			o.clientTest    = options[loc].client.test.dir
			o.clientViews   = options[loc].client.views.dir

		dir: o.dir or dir[loc]
		client:
			dir: o.clientDir or dir.client
			bower:
				dir: o.clientBower or dir.bower
			images:
				dir: o.clientImages or dir.images
			libs:
				dir: o.clientLibs or dir.libs
			scripts:
				dir: o.clientScripts or dir.scripts
			styles:
				dir: o.clientStyles or dir.styles
			test:
				dir: o.clientTest or dir.test
			views:
				dir: o.clientViews or dir.views
		server:
			dir: o.serverDir or dir.server # gets deleted, see removeServerDir
			scripts:
				dir: o.serverDir or dir.scripts

	# dist
	# ====
	config.dist = {}
	config.dist.dir = options.dist.dir or dir.dist # only one dist.dir
	config.dist.rb  = getDirs 'dist'
	config.dist.app = getDirs 'dist', true

	# src
	# ===
	config.src = {}
	config.src.rb  = getDirs 'src'
	config.src.app = getDirs 'src', true

	# format config
	# =============
	formatConfig = (loc, src) ->
		cwd    = ''
		isSrc  = loc is 'src'
		isDist = loc is 'dist'
		if isSrc
			cwd = config.rb.dir if src is 'rb'
			cwd = config.app.dir if src is 'app'
		loc = config[loc][src]
		for own k1, v1 of loc
			if k1 is 'dir'
				loc.dir = path.join cwd, v1
				continue
			for own k2, v2 of v1
				if k2 is 'dir'
					if isDist and src is 'rb'
						v1.dir = path.join loc.dir, v2, config.rb.prefix.distDir
					else
						v1.dir = path.join loc.dir, v2
				else
					v1[k2].dir = path.join v1.dir, v2.dir

	formatConfig 'dist', 'rb'
	formatConfig 'dist', 'app'
	formatConfig 'src',  'rb'
	formatConfig 'src',  'app'

	# add dirName
	# ===========
	addDirName = (loc) ->
		for own k1, v1 of config[loc]
			continue if k1 is 'dir'
			for own k2, v2 of v1
				continue if k2 is 'dir'
				continue if k2 is 'server'
				for own k3, v3 of v2
					continue if k3 is 'dir'
					if k1 is 'app'
						v3.dirName = options[loc].client[k3].dir or dir[k3]
					else
						v3.dirName = dir[k3]
	addDirName 'dist'

	# server
	# ======
	removeServerDir = ->
		['dist', 'src'].forEach (v1) ->
			['app', 'rb'].forEach (v2) ->
				config[v1][v2].server.scripts.dir = config[v1][v2].server.dir
				delete config[v1][v2].server.dir

	addToServerAppDist = ->
		config.dist.app.server.scripts.file = # app server dist entry file
			options.dist.server.fileName or file.appServer

		config.dist.app.server.scripts.path = # absolute path
			path.join config.app.dir, config.dist.app.server.scripts.dir

	removeServerDir()    # server dir is server.scripts.dir
	addToServerAppDist() # add file and path
	config.dist.rb.server.scripts.file = file.rbServer # rb server dist bootstrap file
	config.dist.rb.server.scripts.path = path.join(
		config.dist.rb.server.scripts.dir
		config.dist.rb.server.scripts.file
	)

	# final touch-ups
	# ===============
	formatDist = ->
		['app', 'rb'].forEach (v) ->
			delete config.dist[v].dir

	formatDist() # only one dist.dir

	# logs
	# ====
	# log.json config.dist, 'config.dist ='
	# log.json config.src, 'config.src ='
	# log.json config, 'config ='

	# return
	# ======
	config







