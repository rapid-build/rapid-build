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
		rbServerInit: 'init-server.js' # rb server dist bootstrap file

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
			o.serverTest    = options[loc].server.test.dir

		clientDirName = if loc is 'dist' then o.clientDir or dir.client else null
		serverDirName = if loc is 'dist' then o.serverDir or dir.server else null

		info =
			dir: o.dir or dir[loc]
			client:
				dir: o.clientDir or dir.client
				dirName: clientDirName
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
				dir: o.serverDir or dir.server
				dirName: serverDirName
				scripts:
					dir: o.serverDir or dir.scripts
				test:
					dir: o.serverTest or dir.test
		if loc is 'dist'
			unless isApp
				info.client.dirName = config.rb.prefix.distDir
				info.server.dirName = config.rb.prefix.distDir
		else # delete from src
			delete info.client.dirName
			delete info.server.dirName
		info

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
				continue if k2 is 'dirName'
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
				for own k3, v3 of v2
					continue if k3 is 'dirName'
					continue if k3 is 'dir'
					continue if k2 is 'server' and k3 isnt 'test'
					if k1 is 'app'
						v3.dirName = options[loc][k2][k3].dir or dir[k3]
					else
						v3.dirName = dir[k3]
	addDirName 'dist'

	# server
	# ======
	updateServerScriptsDir = -> # server dir is server.scripts.dir
		['dist', 'src'].forEach (v1) ->
			['app', 'rb'].forEach (v2) ->
				config[v1][v2].server.scripts.dir = config[v1][v2].server.dir

	addToServerRbDist = ->
		config.dist.rb.server.scripts.file = file.rbServerInit # rb server dist bootstrap file
		config.dist.rb.server.scripts.path = path.join(
			config.app.dir
			config.dist.rb.server.scripts.dir
		)
		config.dist.rb.server.scripts.filePath = path.join(
			config.dist.rb.server.scripts.path
			config.dist.rb.server.scripts.file
		)

	addToServerAppDist = ->
		config.dist.app.server.scripts.file = # app server dist entry file
			options.dist.server.fileName or file.appServer

		config.dist.app.server.scripts.path = # absolute path
			path.join config.app.dir, config.dist.app.server.scripts.dir

	updateServerScriptsDir() # server dir is server.scripts.dir
	addToServerRbDist()      # add file, path and filePath
	addToServerAppDist()     # add file and path

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







