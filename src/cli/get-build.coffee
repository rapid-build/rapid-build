module.exports = (config) ->
	# requires
	# ========
	path  = require 'path'
	CSON  = require 'cson'
	merge = require 'deepmerge'

	# helpers
	# =======
	help =
		_throw: (e) ->
			throw e

		isEmptyObj: (obj) ->
			Object.keys(obj).length is 0 and obj.constructor is Object

		isError: (obj) ->
			obj instanceof Error

		getBuildType: (type) ->
			return 'default' if typeof type isnt 'string'
			type = type.trim().toLowerCase()
			return 'default' if /^(test|dev|prod)/i.test(type) is false
			type

		getBuildTypeOpts: (type, extraOpts) ->
			types     = ['common']
			bType     = type.split(':')[0] # base type
			isDev     = /^(default|test|dev)/i.test bType
			start     = if bType is 'default' and extraOpts[2] isnt 'default' then 2 else 3
			extraOpts = extraOpts.slice start
			types.push 'dev'  if isDev
			types.push bType  if bType is 'test'
			types.push 'test' if type.indexOf(':test') isnt -1
			types.push bType  if bType is 'prod'
			types = types.concat extraOpts
			types = help.removeOptsFromTypes types
			types

		getBuildOpts: -> # cson | json | js
			appBuildOpts = config.app.build.opts
			try
				opts = CSON.requireCSONFile "#{appBuildOpts}.cson"
				return help._throw opts.message if help.isError opts
				return opts
			catch e
				try
					return require "#{appBuildOpts}.json"
				catch e
					try
						return require("#{appBuildOpts}.js")()
					catch e
						{}

		removeOptsFromTypes: (types) ->
			optIndex = null # 1st --option
			for i, type of types
				if type.indexOf('--') isnt -1
					optIndex = i
					break
			return types if optIndex is null
			types.slice 0, optIndex

		mergeBuildOpts: (opts, typeOpts) ->
			return {} if help.isEmptyObj opts
			mergedOpts    = {}
			optKeys       = Object.keys opts
			devAndProdOpt = 'devAndProd'
			hasDevAndProd = optKeys.indexOf(devAndProdOpt) isnt -1
			cliOpts       = config.build.cli.opts

			for type in typeOpts
				continue if cliOpts.skipOpts.indexOf(type) isnt -1
				if hasDevAndProd and (type is 'dev' or type is 'prod')
					continue if cliOpts.skipOpts.indexOf(devAndProdOpt) isnt -1
					mergedOpts = merge mergedOpts, opts[devAndProdOpt]
				continue if optKeys.indexOf(type) is -1
				mergedOpts = merge mergedOpts, opts[type]

			mergedOpts

	# configure
	# =========
	build = {}
	build.buildType     = help.getBuildType process.argv[2]
	build.buildTypeOpts = help.getBuildTypeOpts build.buildType, process.argv
	build.buildOpts     = help.getBuildOpts()
	build.buildOpts     = help.mergeBuildOpts build.buildOpts, build.buildTypeOpts
	build.execute       = require(config.build.path) build.buildOpts

	# return
	# ======
	build
