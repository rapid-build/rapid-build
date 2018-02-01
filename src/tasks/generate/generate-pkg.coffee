module.exports = (config, gulp, Task) ->
	q    = require 'q'
	del  = require 'del'
	log  = require "#{config.req.helpers}/log"
	path = require 'path'
	fse  = require 'fs-extra'

	# helpers
	# =======
	delDir = (_path, item) ->
		del(_path, force:true).then (paths) ->
			message: "cleaned generated: #{item}"

	createJson = (_path) ->
		format = spaces: '\t'
		fse.writeJson(_path, {}, format).then ->
			dir  = config.generated.pkg.dir
			file = path.basename _path
			message: "generated json file: #{dir} #{file}"

	createDir = (dir) ->
		_path = config.generated.pkg[dir].path
		fse.mkdirs(_path).then ->
			message: "generated directory: #{path.join config.generated.pkg.dir, dir}"

	# private
	# =======
	_api =
		delete:
			pkgs: ->
				_path = config.generated.path
				paths = [path.join(_path,'*'), '!'+path.join(_path,'.gitkeep')]
				delDir paths, 'directories'

			pkg: ->
				delDir config.generated.pkg.path, "#{config.generated.pkg.dir} directory"

		clean:
			pkg: ->
				root   = path.join config.generated.pkg.path, '*.*'
				files  = config.generated.pkg.files.path
				temp   = config.generated.pkg.temp.path
				server = path.join config.src.rb.server.dir
				client = path.join config.src.rb.client.dir, '*'
				bower  = "!#{config.src.rb.client.bower.dir}"
				paths  = [root, files, temp, server, client, bower]
				delDir paths, "#{config.generated.pkg.dir} files"

		cleanup:
			pkg: ->
				serverPkg     = config.generated.pkg.src.server.pkg
				paths         = [serverPkg]
				serverPkgPath = path.join 'src', 'server', path.basename serverPkg
				delDir paths, "#{config.generated.pkg.dir} #{serverPkgPath}"

		create:
			dirs: ->
				q.all([
					createDir 'files'
					createDir 'temp'
				]).then ->
					message: [
						"generated directory: #{path.join config.generated.pkg.dir, 'files'}"
						"generated directory: #{path.join config.generated.pkg.dir, 'temp'}"
					]

			jsonFiles: ->
				pkg   = config.generated.pkg
				files = pkg.files
				q.all([
					createJson pkg.config
					createJson files.files
					createJson files.testFiles
					createJson files.prodFiles
					createJson files.prodFilesBlueprint
				]).then ->
					message: "generated json files: #{config.generated.pkg.dir}"

		copy:
			src: ->
				src  = path.join config.rb.dir, 'src'
				dest = config.generated.pkg.src.path
				opts = overwrite: true, filter: (s) -> not /\.gitkeep$/ig.test s
				fse.copy(src, dest, opts).then ->
					dir = config.generated.pkg.dir
					message: "generated directory: #{path.join dir, 'src'}"

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				# -> _api.delete.pkgs() # for build dev
				# -> _api.delete.pkg()  # for build dev
				-> _api.clean.pkg()
				-> _api.create.dirs()
				-> _api.create.jsonFiles()
				-> _api.copy.src()
				-> _api.cleanup.pkg()
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: "generated directory: #{config.generated.pkg.dir}"


	# return
	# ======
	api.runTask()