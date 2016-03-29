module.exports = (app, config) ->
	port = process.env.PORT or config.ports.server

	# must return server
	# ==================
	server = app.listen port, ->
		console.log "Server started on port #{port}"