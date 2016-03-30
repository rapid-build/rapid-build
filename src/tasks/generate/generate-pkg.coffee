module.exports = (config) ->
	q    = require 'q'
	del  = require 'del'
	path = require 'path'
	fse  = require 'fs-extra'

	# helpers
	# =======
	delDir = (_path, dir) ->
		defer = q.defer()
		del(_path, force:true).then (paths) ->
			dirMsg = 'generated'
			dirMsg += " #{dir}" if dir
			console.log "cleaned #{dirMsg} directory".yellow
			defer.resolve()
		defer.promise

	createJson = (_path) ->
		defer  = q.defer()
		format = spaces: '\t'
		fse.writeJson _path, {}, format, (e) ->
			dir  = config.generated.pkg.dir
			file = path.basename _path
			# console.log "generated #{dir}: #{file}".yellow
			defer.resolve()
		defer.promise

	# private
	# =======
	_api =
		delete:
			pkgs: ->
				_path = config.generated.path
				paths = [path.join(_path,'*'), '!'+path.join(_path,'.gitkeep')]
				delDir paths

			pkg: ->
				delDir config.generated.pkg.path, config.generated.pkg.dir

		clean:
			pkg: ->
				root   = path.join config.generated.pkg.path, '*.*'
				files  = config.generated.pkg.files.path
				server = path.join config.src.rb.server.dir
				client = path.join config.src.rb.client.dir, '*'
				bower  = "!#{config.src.rb.client.bower.dir}"
				paths  = [root, files, server, client, bower]
				delDir paths, config.generated.pkg.dir

		create:
			dirs: ->
				defer = q.defer()
				_path = config.generated.pkg.files.path
				fse.mkdirs _path, (e) ->
					dir = config.generated.pkg.dir
					console.log "generated #{dir} directory".yellow
					defer.resolve()
				defer.promise

			jsonFiles: ->
				pkg   = config.generated.pkg
				files = pkg.files
				q.all([
					createJson pkg.config
					createJson pkg.bower
					createJson files.files
					createJson files.testFiles
					createJson files.prodFiles
					createJson files.prodFilesBlueprint
				])
				# .done -> console.log "generated #{config.generated.pkg.dir} json files".yellow

		copy:
			src: ->
				defer = q.defer()
				src   = path.join config.rb.dir, 'src'
				dest  = config.generated.pkg.src.path
				opts  = clobber: true, filter: (s) -> not /\.gitkeep$/ig.test s
				fse.copy src, dest, opts, (e) ->
					dir = config.generated.pkg.dir
					# console.log "generated #{dir} src directory".yellow
					defer.resolve()
				defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			defer = q.defer()
			tasks = [
				# -> _api.delete.pkgs() # for build dev
				# -> _api.delete.pkg()  # for build dev
				-> _api.clean.pkg()
				-> _api.create.dirs()
				-> _api.create.jsonFiles()
				-> _api.copy.src()
			]
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise


	# return
	# ======
	api.runTask()