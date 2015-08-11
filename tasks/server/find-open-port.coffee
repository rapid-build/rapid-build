module.exports = (gulp, config) ->
	q           = require 'q'
	fse         = require 'fs-extra'
	findPort    = require 'find-port'
	promiseHelp = require "#{config.req.helpers}/promise"

	# global
	# ======
	updateConfig = false

	# helpers
	# =======
	isPortUsed = (server, openPorts, configPort) ->
		used = openPorts.indexOf(configPort) is -1
		# console.log "is #{server} port #{configPort} used: #{used}".yellow
		updateConfig = true if used and updateConfig is false
		used

	getConfigPorts = ->
		ports = []
		for server, port of config.ports
			ports.push port
		ports

	getNewPort = (openPorts) ->
		configPorts = getConfigPorts()
		newPort = null
		for openPort in openPorts
			if configPorts.indexOf(openPort) is -1
				newPort = openPort
				break
		newPort

	# tasks
	# =====
	setPort = (server) ->
		defer      = q.defer()
		configPort = config.ports[server]
		start      = configPort
		end        = start + 10
		range      = [start..end]
		findPort range, (openPorts) ->
			portUsed = isPortUsed server, openPorts, configPort
			return defer.resolve() unless portUsed
			config.ports[server] = getNewPort openPorts
			msg = "#{server} port switched to #{config.ports[server]} because #{configPort} was in use"
			console.log msg.yellow
			defer.resolve()
		defer.promise

	setPorts = -> # synchronously
		defer = q.defer()
		tasks = [
			-> setPort 'server'
			-> setPort 'reload'
			-> setPort 'reloadUI'
			-> setPort 'test'
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	updateConfigFile = ->
		return promiseHelp.get() unless updateConfig
		# console.log 'update config:', updateConfig
		defer      = q.defer()
		format     = spaces: '\t'
		configFile = config.templates.config.dest.path
		fse.writeJson configFile, config, format, (e) ->
			defer.resolve()
		defer.promise

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			-> setPorts()
			-> updateConfigFile()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}find-open-port", ->
		runTasks()


