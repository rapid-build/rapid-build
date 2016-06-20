# app static files directory
# ==========================
module.exports = (server, config) ->
	server.app.use server.express.static server.paths.client