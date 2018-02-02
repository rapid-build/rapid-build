# WATCH STORE
# ===========
# WATCHES (hashmap)
# watchType: [      (ex: client or client-test)
# 	task: ''        (task name ex: copy-html)
#	glob: [''] | '' (glob(s))
#	opts: {}        (various options)
# ]
# =============================================
Watches = {} # :Object[Object]

class Singleton
	@getInstance: (config) ->
		@instance ?= new WatchStore config

class WatchStore
	constructor: (config) ->
		@_addWatches config, 'client'       if config.build.client
		@_addWatches config, 'client-test'  if config.build.client and config.env.is.testClient
		@_addWatches config, 'client-extra' if config.build.client and config.extra.watch.app.client.length
		@_addWatches config, 'server'       if config.build.server
		@_addWatches config, 'server-test'  if config.build.server and config.env.is.testServer
		@_addWatches config, 'server-extra' if config.build.server and config.extra.watch.app.server.length

	# Public
	# ======
	getWatches: -> # :Watches
		Watches

	# Private
	# =======
	_addWatches: (config, type) -> # :void
		Watches[type] = [] unless Watches[type]
		watches = require("#{config.req.watches}/watches-#{type}") config
		Watches[type].push watches...

# Export It!
# ==========
module.exports = Singleton.getInstance

