module.exports = (config) ->
	# requires
	# ========
	path = require 'path'
	fse  = require 'fs-extra'

	# vars
	# ====
	appPath  = config.app.path
	locs     = config.build.cli.opts.quickStart
	mkClient = locs.indexOf('client') isnt -1
	mkServer = locs.indexOf('server') isnt -1
	opts     = overwrite: false

	# make dirs
	# =========
	if mkClient
		for dir, i in ['images','libs','scripts','styles','test','views']
			fse.mkdirsSync "#{appPath}/src/client/#{dir}"

	if mkServer
		for dir, i in ['test']
			fse.mkdirsSync "#{appPath}/src/server/#{dir}"

	# make files
	# ==========
	# root files
	try	fse.copySync "#{config.build.cli.templates.root}/gitignore.sh", "#{appPath}/.gitignore", opts
	for file, i in ["#{config.build.pkg.name}.cson"]
		try	fse.copySync "#{config.build.cli.templates.root}/#{file}", "#{appPath}/#{file}", opts

	if mkClient
		for file, i in ['scripts/html5.es6', 'scripts/router.es6', 'styles/app.less', 'views/home.html']
			try	fse.copySync "#{config.build.cli.templates.client}/#{file}", "#{appPath}/src/client/#{file}", opts

	if mkServer
		for file, i in ['routes.es6']
			try	fse.copySync "#{config.build.cli.templates.server}/#{file}", "#{appPath}/src/server/#{file}", opts

	# message
	# =======
	console.log "Quick start complete! Now run: #{config.build.pkg.name} dev".attn
