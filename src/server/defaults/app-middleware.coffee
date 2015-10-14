# default app middleware
# ======================
module.exports = (server, config) ->
	server.app.use server.express.static server.paths.client
	server.app.use server.middleware.bodyParser.json() # parse application/json