# API
# bowerHelper.has.bower appOrRb
# bowerHelper.has.installed.pkg 'angular', appOrRb
# bowerHelper.get.json.from.appOrRb appOrRb
# bowerHelper.get.json.from.pkg 'angular', appOrRb
# bowerHelper.get.pkgs.from.appOrRb appOrRb
# bowerHelper.get.pkgs.to.install appOrRb
# bowerHelper.get.pkgs.to.install appOrRb, true
# bowerHelper.get.installed.pkgs appOrRb
# bowerHelper.get.installed.pkg 'angular', appOrRb
# bowerHelper.get.missing.pkgs appOrRb
# bowerHelper.get.src appOrRb, opts
# ================================================
module.exports = (config) ->
	fs       = require 'fs'
	fse      = require 'fs-extra'
	path     = require 'path'
	del      = require 'del'
	log      = require "#{config.req.helpers}/log"
	isType   = require "#{config.req.helpers}/isType"
	pathHelp = require "#{config.req.helpers}/path"
	fileHelp = require("#{config.req.helpers}/file") config

	# helpers
	# =======
	helper =
		getPath: (pkgName, file, loc='rb') ->
			path.join(
				config.src[loc].client.bower.dir
				pkgName
				file
			)

		getDevFile: (file) ->
			return file.substr 1 if file.indexOf('/') is 0
			return file.substr 2 if file.indexOf('./') is 0
			file

		getProdFile: (file) ->
			dir     = path.dirname file
			dir     = '' if dir is '.'
			ext     = path.extname file
			base    = path.basename file, ext
			minFile = path.join dir, "#{base}.min#{ext}"
			minFile

		getDevFileInfo: (pkgName, files, loc='rb') ->
			_files = []
			files  = [ files ] if isType.string files
			files.forEach (file) =>
				_file = @getDevFile file
				_path = @getPath pkgName, _file, loc
				_files.push file: _file, path: _path
			_files

		getProdFileInfo: (pkgName, files, loc='rb') ->
			_files = []
			files.forEach (file) =>
				_file = @getProdFile file.file
				_path = @getPath pkgName, _file, loc
				if not fileHelp.exists _path
					_files.push file
				else
					_files.push file: _file, path: _path
			_files

		getPkgDeps: (deps) ->
			return null unless deps
			return null unless isType.object deps
			return null unless Object.keys(deps).length
			deps

		getPkg: (pkg, loc='rb') ->
			devFileInfo  = @getDevFileInfo  pkg.name, pkg.main, loc
			prodFileInfo = @getProdFileInfo pkg.name, devFileInfo, loc
			pkgDeps      = @getPkgDeps pkg.dependencies
			# log.json pkgDeps
			name:    pkg.name
			version: pkg.version
			dev:     devFileInfo
			prod:    prodFileInfo
			deps:    pkgDeps

		getSubPkgs: (pkgs) ->
			return null unless pkgs.length
			# log.json pkgs
			rbPkgs  = if me.has.bower 'rb'  then me.get.pkgs.from.appOrRb 'rb'  else {}
			appPkgs = if me.has.bower 'app' then me.get.pkgs.from.appOrRb 'app' else {}
			allPkgs = Object.keys(rbPkgs).concat Object.keys appPkgs
			return null unless allPkgs.length
			subPkgs = {}
			for own i, pkg of pkgs
				continue unless pkg.deps
				for own name, version of pkg.deps
					continue if allPkgs.indexOf(name) isnt -1
					subPkgs[name] = version
			return null unless Object.keys(subPkgs).length
			# log.json subPkgs
			subPkgs

		getInstalledPkgs: (pkgsObj, loc) ->
			pkgs = []
			for own pkg, version of pkgsObj
				_pkg = me.get.installed.pkg pkg, loc
				pkgs.push _pkg if _pkg
			pkgs

		depsHaveChanged: (bowerJson, storedJson) ->
			changed  = false
			bDeps    = bowerJson.dependencies
			sDeps    = storedJson.dependencies
			bDepsTot = Object.keys(bDeps).length
			sDepsTot = Object.keys(sDeps).length
			return true if bDepsTot isnt sDepsTot
			for own pkg, version of bDeps
				if not sDeps[pkg] or sDeps[pkg] isnt version
					changed = true; break
			changed

		forceInstall: (loc='rb') -> # technique for users to get bower updates
			force     = false
			bowerJson = me.get.json.from.appOrRb(loc)
			dir       = config.src[loc].client.bower.dir
			_path     = path.join dir, '.bower'

			if not fileHelp.exists _path
				force = true
			else
				storedJson = fileHelp.read.json _path
				if bowerJson.version isnt storedJson.version
					force = true
				else if @depsHaveChanged bowerJson, storedJson
					force = true
				if force
					del.sync dir, force:true
					log.task "cleaned #{loc} bower_components directory"

			fse.mkdirsSync dir
			fileHelp.write.json _path, bowerJson if force
			force

		_removeRbAngularMocks: (paths) ->
			key = 'angular-mocks'
			if paths.absolute.length
				index = null
				paths.absolute.forEach (_path, i) ->
					return index = i if _path.indexOf(key) isnt -1
				return if index is null
				paths.absolute.splice index, 1   # remove from absolutes
				for own k, v of paths.relative
					if v.indexOf(key) isnt -1
						delete paths.relative[k] # remove from relatives
						break

		removeRbAngularMocks: (loc, paths) ->
			return if loc isnt 'rb'
			if config.env.is.prod
				@_removeRbAngularMocks paths unless config.angular.httpBackend.prod
			else if not config.angular.httpBackend.dev
				@_removeRbAngularMocks paths

	me =
		has:
			bower: (loc='rb') ->
				fileHelp.exists config.bower[loc].path

			installed:
				pkg: (pkg, loc='rb') ->
					dir   = config.src[loc].client.bower.dir
					file  = ".#{config.bower[loc].file}"
					_path = path.join dir, pkg, file
					fileHelp.exists _path
		get:
			json:
				from:
					appOrRb: (loc='rb') ->
						require config.bower[loc].path

					pkg: (pkg, loc='rb') ->
						return unless me.has.installed.pkg pkg, loc
						# console.log pkg, loc
						dir   = config.src[loc].client.bower.dir
						file  = ".#{config.bower[loc].file}"
						_path = path.join dir, pkg, file
						bowerJson = require _path

			pkgs:
				from:
					appOrRb: (loc='rb') ->
						mainDeps = me.get.json.from.appOrRb(loc).dependencies
						# log.json mainDeps
						mainDeps
				to:
					install: (loc='rb', force=false) ->
						return unless me.has.bower loc
						force   = helper.forceInstall loc unless force
						pkgs    = []
						pkgsObj = me.get.pkgs.from.appOrRb loc
						if force
							for own pkg, version of pkgsObj
								pkgs.push "#{pkg}##{version}"
						else
							missing = me.get.missing.pkgs loc
							for own pkg, version of pkgsObj
								_pkg = "#{pkg}##{version}"
								continue if missing.indexOf(_pkg) is -1
								pkgs.push _pkg
						pkgs

			installed:
				pkg: (pkg, loc='rb') ->
					pkg = me.get.json.from.pkg pkg, loc
					return unless pkg
					# log.json pkg
					helper.getPkg pkg, loc

				pkgs: (loc='rb') ->
					pkgs    = []
					pkgsObj = me.get.pkgs.from.appOrRb loc
					pkgs    = helper.getInstalledPkgs pkgsObj, loc if pkgsObj
					# log.json pkgs
					if pkgs.length
						subPkgs    = []
						subPkgsObj = helper.getSubPkgs pkgs
						subPkgs    = helper.getInstalledPkgs subPkgsObj, loc if subPkgsObj
						pkgs       = pkgs.concat subPkgs if subPkgs.length
					# log.json pkgs
					pkgs

			missing:
				pkgs: (loc='rb') ->
					pkgs  = []
					jPkgs = me.get.pkgs.from.appOrRb loc
					iPkgs = me.get.installed.pkgs loc
					# log.json iPkgs
					for own pkg, version of jPkgs
						missing = true
						iPkgs.forEach (v) ->
							missing = false if v.name.toLowerCase() is pkg.toLowerCase()
						pkgs.push "#{pkg}##{version}" if missing
					pkgs

			src: (loc='rb', opts={}) ->
				return unless me.has.bower loc
				env      = opts.env
				env      = 'prod' if not env and config.env.is.prod
				env      = 'dev' if ['dev','prod'].indexOf(env) is -1
				absPaths = []
				relPaths = {}
				if opts.pkg
					pkgs = [ me.get.installed.pkg opts.pkg, loc ]
				else
					pkgs = me.get.installed.pkgs loc
				# log.json pkgs
				pkgs.forEach (pkg) ->
					pkg[env].forEach (file) ->
						hasPath = pathHelp.format(file.file).indexOf('/') isnt -1
						name    = if hasPath then pkg.name else ''
						relPaths[file.path] = path.join name, file.file
						absPaths.push file.path
				paths =
					absolute: absPaths # []
					relative: relPaths # {}
				helper.removeRbAngularMocks loc, paths unless opts.test
				{ paths }



