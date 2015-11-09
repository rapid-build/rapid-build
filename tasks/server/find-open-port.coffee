# Updates config.ports if a port is in use.
# =========================================
module.exports = (config, gulp, taskOpts={}) ->
	q           = require 'q'
	findPort    = require 'find-port'
	promiseHelp = require "#{config.req.helpers}/promise"
	configHelp  = require("#{config.req.helpers}/config") config

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

	setPorts = (forTestClientPort) -> # synchronously
		defer = q.defer()
		switch !!forTestClientPort
			when true then tasks = [ -> setPort 'test' ]
			else
				return promiseHelp.get defer unless config.build.server
				return promiseHelp.get defer if config.exclude.default.server.files
				tasks = [
					-> setPort 'server'
					-> setPort 'reload'
					-> setPort 'reloadUI'
				]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) -> # synchronously
			defer = q.defer()
			forTestClientPort = loc is 'test:client'
			tasks = [
				-> setPorts forTestClientPort
				-> configHelp.buildFile buildConfigFile, 'rebuild'
			]
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask taskOpts.loc



