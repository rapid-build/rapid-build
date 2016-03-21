module.exports = (server) ->
	app = server.app

	# data
	# ====
	Heroes   = require './data/heroes'
	Villains = require './data/villains'

	# heroes
	# ======
	app.get '/api/heroes', (req, res) ->
		res.status(200).json Heroes

	app.get '/api/heroes/:id', (req, res) ->
		id    = parseInt req.params.id
		model = item for item in Heroes when item.id is id
		model = model or {}
		res.status(200).json model

	app.post '/api/heroes', (req, res) ->
		tot      = Heroes.length
		id       = if tot then Heroes[tot - 1].id + 1 else 1
		model    = req.body
		username = model.name.replace(/\s/g, '-').toLowerCase()
		model    = { id, name: model.name, username }
		Heroes.push model
		res.status(200).json model

	app.put '/api/heroes/:id', (req, res) ->
		id            = parseInt req.params.id
		model         = item for item in Heroes when item.id is id
		index         = Heroes.indexOf model
		Heroes[index] = req.body
		model         = Heroes[index]
		res.status(200).json model

	app.delete '/api/heroes/:id', (req, res) ->
		id    = parseInt req.params.id
		model = item for item in Heroes when item.id is id
		index = Heroes.indexOf model
		Heroes.splice index, 1
		res.status(200).json { success: true}

	# villains
	# ========
	app.get '/api/villains', (req, res) ->
		res.status(200).json Villains





