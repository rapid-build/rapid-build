module.exports = ->
	q      = require 'q'
	server = require('./server').server
	port   = server.address().port

	defer = q.defer()
	server.close ->
		console.log "Server stopped on port #{port}"
		defer.resolve()

	defer.promise
