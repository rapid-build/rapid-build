module.exports = (config, options) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	isType   = require "#{config.req.helpers}/isType"
	pathHelp = require "#{config.req.helpers}/path"

	# defaults
	# ========
	dir =
		dist:         'dist'
		src:          'src'
		client:       'client'
		images:       'images'
		libs:         'libs'
		server:       'server'
		scripts:      'scripts'
		styles:       'styles'
		test:         'test'
		typings:      'typings'
		views:        'views'
		bower:        'bower_components'
		node_modules: 'node_modules'

	file =
		appServer: 'routes.js' # app server dist entry file
		rbServer: # rb server dist
			info:  'server-info.json'
			start: 'start-server.js'
			stop:  'stop-server.js'

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
				node_modules:
					dir: dir.node_modules # no option to name node_modules dir
				scripts:
					dir: o.clientScripts or dir.scripts
				styles:
					dir: o.clientStyles or dir.styles
				test:
					dir: o.clientTest or dir.test
				typings:
					dir: dir.typings
				views:
					dir: o.clientViews or dir.views
			server:
				dir: o.serverDir or dir.server
				dirName: serverDirName
				scripts:
					dir: o.serverDir or dir.scripts
				node_modules:
					dir: dir.node_modules
				test:
					dir: o.serverTest or dir.test
				typings:
					dir: dir.typings
		if loc is 'dist'
			delete info.client.typings
			delete info.server.typings
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
			cwd = config.generated.pkg.path if src is 'rb' # was config.rb.dir
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

	# add dirName (to dist)
	# =====================
	addDirName = (loc) ->
		for own k1, v1 of config[loc]
			continue if k1 is 'dir'
			for own k2, v2 of v1
				continue if k2 is 'dir'
				for own k3, v3 of v2
					continue if k3 is 'dirName'
					continue if k3 is 'dir'
					continue if k2 is 'server' and ['node_modules','test'].indexOf(k3) is -1
					if k1 is 'app' and k3 isnt 'node_modules'
						v3.dirName = options[loc][k2][k3].dir or dir[k3]
					else
						v3.dirName = dir[k3]
	addDirName 'dist'

	# add root to locs
	# ================
	addRootClientAndServerDir = ->
		for distOrSrc in ['dist', 'src']
			for appOrRb in ['rb', 'app']
				for clientOrServer in ['client', 'server']
					dirs = config[distOrSrc][appOrRb][clientOrServer]
					dirs.root = dir: dirs.dir

	addRootClientAndServerDir()

	# server
	# ======
	updateServerScriptsDir = -> # server dir is server.scripts.dir
		['dist', 'src'].forEach (v1) ->
			['app', 'rb'].forEach (v2) ->
				config[v1][v2].server.scripts.dir = config[v1][v2].server.dir

	addToServerRbDist = ->
		config.dist.rb.server.scripts.path = path.join(
			config.app.dir
			config.dist.rb.server.scripts.dir
		)

		config.dist.rb.server.scripts.startFile = file.rbServer.start
		config.dist.rb.server.scripts.stopFile  = file.rbServer.stop

		_path = config.dist.rb.server.scripts.path
		config.dist.rb.server.scripts.info  = path.join _path, file.rbServer.info
		config.dist.rb.server.scripts.start = path.join _path, file.rbServer.start
		config.dist.rb.server.scripts.stop  = path.join _path, file.rbServer.stop

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

	# absolute client paths
	# =====================
	config.dist.client = {}
	config.dist.client.paths = {}
	config.dist.client.paths.absolute = if options.dist.client.paths.absolute is null then true else !!options.dist.client.paths.absolute

	# pack dist helpers
	# =================
	pack =
		format:
			opts: { 'tar', 'tgz', 'zip' }
		get:
			base: (includeBase) ->
				return '.' if includeBase # pack dist folder and contents
				config.dist.dir           # pack dist contents

			format: (format='zip') ->
				format = format.toLowerCase()
				format = pack.format.opts[format]
				return pack.format.opts.zip unless format
				format

			fileName: (format, fileName='dist') -> # return ex: dist.zip
				formatExt = ".#{format}"
				fileName  = path.basename fileName, formatExt
				"#{fileName}.#{format}"

			filePath: (fileName) -> # place file in project root
				path.join config.app.dir, fileName


			glob: (glob='**') -> # glob: string | string[]
				glob = if isType.stringArray glob
				then @globPatterns glob
				else @globPattern glob
				# console.log 'GLOB:'.info, glob
				glob

			globPattern: (glob) -> # glob pattern: string
				negate    = '!'
				glob      = glob.trim()
				return glob unless glob.length
				isNegated = glob[0] is negate
				glob      = glob.slice 1 if isNegated
				glob      = path.join config.dist.dir, glob # prepend dist directory name
				glob      = pathHelp.format glob            # glob needs forward back slashes
				glob      = "#{negate}#{glob}" if isNegated # prepend !
				glob

			globPatterns: (glob) -> # string[pattern]
				return glob unless glob.length
				for v, i in glob
					glob[i] = @globPattern v
				glob

			isFormatMap: (fileName) -> # return: {} of is format flags
				map = {}
				for own key, val of pack.format.opts
					map[key] = fileName.indexOf(".#{val}") != -1
				map.gzip = map.tgz # extra info
				map

	# pack dist (in order)
	# ====================
	config.dist.pack = {}
	config.dist.pack.enabled     = if options.dist.pack.enable is null then false else options.dist.pack.enable
	config.dist.pack.format      = pack.get.format options.dist.pack.format
	config.dist.pack.fileName    = pack.get.fileName config.dist.pack.format, options.dist.pack.fileName
	config.dist.pack.filePath    = pack.get.filePath config.dist.pack.fileName
	config.dist.pack.glob        = pack.get.glob options.dist.pack.glob
	config.dist.pack.includeBase = if options.dist.pack.includeBase is null then false else options.dist.pack.includeBase
	config.dist.pack.base        = pack.get.base config.dist.pack.includeBase
	config.dist.pack.is          = pack.get.isFormatMap config.dist.pack.fileName

	# logs
	# ====
	# log.json config.dist, 'config.dist ='
	# log.json config.src, 'config.src ='
	# log.json config, 'config ='

	# return
	# ======
	config







