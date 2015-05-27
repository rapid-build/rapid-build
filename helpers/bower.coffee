# API
# bowerHelper.has.installed.pkg 'angular'
# bowerHelper.get.json.from.rb()
# bowerHelper.get.json.from.pkg 'angular'
# bowerHelper.get.pkgs.from.rb()
# bowerHelper.get.pkgs.to.install()
# bowerHelper.get.pkgs.to.install true
# bowerHelper.get.installed.pkgs()
# bowerHelper.get.installed.pkg 'angular'
# bowerHelper.get.missing.pkgs()
# =======================================
module.exports = (config) ->
	fs   = require 'fs'
	path = require 'path'

	# helpers
	# =======
	helper =
		isFile: (_path) ->
			try
				fs.lstatSync(_path).isFile()
			catch e
				false

		getPath: (pkgName, file) ->
			path.join(
				config.src.rb.client.libs.dir
				pkgName
				file
			)

		getDevFile: (file) ->
			return file.substr 1 if file.indexOf('/') is 0
			return file.substr 2 if file.indexOf('./') is 0
			file

		getProdFile: (file) ->
			ext  = path.extname file
			base = path.basename file, ext
			"#{base}.min#{ext}"

		getDevFileInfo: (pkgName, file) ->
			file  = @getDevFile file
			_path = @getPath pkgName, file
			{ file, path: _path }

		getProdFileInfo: (pkgName, fileInfo) ->
			file  = @getProdFile fileInfo.file
			_path = @getPath pkgName, file
			return fileInfo if not @isFile _path
			{ file, path: _path }

		getPkg: (pkg) ->
			devFileInfo  = @getDevFileInfo  pkg.name, pkg.main
			prodFileInfo = @getProdFileInfo pkg.name, devFileInfo
			name:    pkg.name
			version: pkg.version
			dev:     devFileInfo
			prod:    prodFileInfo

		writeVersionFile: (file, version) ->
			fs.writeFileSync file, version
			true

		forceInstall: -> # technique for users to get bower updates
			version = me.get.json.from.rb().version
			file    = path.join config.src.rb.client.libs.dir, '.bower'
			if not @isFile file
				@writeVersionFile file, version
			else
				storedVersion = fs.readFileSync(file).toString()
				return false if storedVersion is version
				@writeVersionFile file, version

	me =
		has:
			installed:
				pkg: (pkg) ->
					try
						fs.lstatSync(
							path.join(
								config.src.rb.client.libs.dir
								pkg
								config.json.bower.file
							)
						).isFile()
					catch e
						false
		get:
			json:
				from:
					rb: ->
						require config.json.bower.path
					pkg: (pkg) ->
						return if not me.has.installed.pkg pkg
						require(
							path.join(
								config.src.rb.client.libs.dir
								pkg
								config.json.bower.file
							)
						)

			pkgs:
				from:
					rb: ->
						me.get.json.from.rb().dependencies
				to:
					install: (force = false) ->
						force   = helper.forceInstall() if not force
						pkgs    = []
						pkgsObj = me.get.pkgs.from.rb()
						if force
							for own pkg, version of pkgsObj
								pkgs.push "#{pkg}##{version}"
						else
							missing = me.get.missing.pkgs()
							for own pkg, version of pkgsObj
								_pkg = "#{pkg}##{version}"
								continue if missing.indexOf(_pkg) is -1
								pkgs.push _pkg
						pkgs

			installed:
				pkg: (pkg) ->
					pkg = me.get.json.from.pkg pkg
					return if not pkg
					helper.getPkg pkg
				pkgs: ->
					pkgs    = []
					pkgsObj = me.get.pkgs.from.rb()
					for own pkg, version of pkgsObj
						_pkg = @pkg pkg
						pkgs.push _pkg if _pkg
					pkgs

			missing:
				pkgs: ->
					pkgs   = []
					rbPkgs = me.get.pkgs.from.rb()
					iPkgs  = me.get.installed.pkgs()
					for own pkg, version of rbPkgs
						missing = true
						iPkgs.forEach (v) ->
							missing = false if v.name is pkg
						pkgs.push "#{pkg}##{version}" if missing
					pkgs

			src: (env) ->
				env   = env or config.env.name
				env   = 'dev' if ['dev','prod'].indexOf(env) is -1
				paths = []
				pkgs  = me.get.installed.pkgs()
				pkgs.forEach (pkg) ->
					paths.push pkg[env].path
				paths


