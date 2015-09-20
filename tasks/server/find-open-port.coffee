module.exports = (gulp, config) ->
	q          = require 'q'
	fse        = require 'fs-extra'
	findPort   = require 'find-port'
	configHelp = require("#{config.req.helpers}/config") config

	# global
	# ======
	buildConfigFile = false

	# helpers
	# =======
	isPortUsed = (server, openPorts, configPort) ->
		used = openPorts.indexOf(configPort) is -1
		# console.log "is #{server} port #{configPort} used: #{used}".yellow
		buildConfigFile = true if used and buildConfigFile is false
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

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			-> setPorts()
			-> configHelp.buildFile buildConfigFile, 'rebuild'
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}find-open-port", ->
		runTasks()


