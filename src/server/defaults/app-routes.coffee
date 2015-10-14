# default app routes
# ==================
module.exports = (server, config) ->
	spa = config.spa.dist.file # ex: spa.html

	server.app.get '*', (req, res) ->
		msg = 'Hello Server!'
		return res.send msg unless config.build.client
		return res.send msg if config.exclude.spa
		return res.send msg if config.env.is.test and not config.env.is.testClient
		res.sendFile spa, root: server.paths.client