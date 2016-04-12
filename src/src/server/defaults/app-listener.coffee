module.exports = (server, config) ->
	port = process.env.PORT or config.ports.server

	# must return
	# ===========
	server.app.listen port, ->
		console.log "Server started on port #{port}"