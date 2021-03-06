# TYPESCRIPT PROJECT FACTORY
# needed for watch to use same ts project
# =======================================
fs         = require 'fs'
typescript = require 'typescript' # use build's ts version

class TsProject
	# typescript instance locations
	# =============================
	instances = {}

	# private
	# =======
	help =
		fileExists: (_path) ->
			try fs.lstatSync(_path).isFile()
			catch e then false

		hasTsConfig: (tsconfigPath) ->
			hasTsConfig = @fileExists tsconfigPath
			# console.log "Has tsconfig.json: #{hasTsConfig}".alert
			hasTsConfig

	# @id       = location (ex: client or server)
	# @ts       = gulp-typescript
	# @tsconfig = tsconfig.json path
	# @opts     = ts project options
	# ===========================================
	class Typescript
		constructor: (@id, @ts, @tsconfig, @opts={}) ->
			@hasTsConfig     = help.hasTsConfig @tsconfig
			@opts.typescript = typescript
			return @setProject().setProjectConfig().getProject()

		setProject: ->
			if @hasTsConfig
				@project = @ts.createProject @tsconfig, @opts
			else
				@project = @ts.createProject @opts
			@

		setProjectConfig: ->
			return @ if @hasTsConfig
			# gulp-typescript needs these set if no tsconfig.json
			@project.config = {}
			@project.configFileName  = @tsconfig
			@project.options.rootDir = './'
			@

		getProject: ->
			@project

	# static method to retrieve an
	# instance or create a new one
	# ============================
	@get: (id, ts, tsconfig, opts) ->
		if not instances[id] # create new instance
			# console.log "TS INSTANCE ID: #{id}".alert
			instances[id] = new Typescript id, ts, tsconfig, opts
		instances[id]

# Export Class!
# =============
module.exports = TsProject


