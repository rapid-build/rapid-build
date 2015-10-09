# default app configuration
# =========================
module.exports = (server, config) ->
	app = server.app
	spa = config.spa.dist.file # ex: spa.html

	app.set 'x-powered-by', false # removes this http header
	app.use server.express.static server.paths.client
	app.use server.middleware.bodyParser.json() # parse application/json

	app.get '*', (req, res) ->
		msg = 'Hello Server!'
		return res.send msg unless config.build.client
		return res.send msg if config.exclude.spa
		return res.send msg if config.env.is.test and not config.env.is.testClient
		res.sendFile spa, root: server.paths.client