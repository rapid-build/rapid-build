# default app settings
# ====================
module.exports = (server, config) ->
	server.app.set 'x-powered-by', false # removes this http header