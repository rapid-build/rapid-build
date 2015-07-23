path        = require 'path'
express     = require 'express'
config      = require './config.json'
app         = express()
port        = config.ports.server
spa         = config.spa.dist.file
client      = config.dist.app.client.dir
appPath     = config.dist.app.server.scripts.path
appFile     = config.dist.app.server.scripts.file
appFilePath = path.join appPath, appFile # app server dist entry script

app.use express.static client
app.listen port, ->
	console.log "Server Started on #{config.ports.server}"

app.get '/', (req, res) ->
	res.sendFile spa, root:client

# options to pass
# ===============
opts =
	dir:
		relative: config.dist.app.server.scripts.dir
		absolute: config.dist.app.server.scripts.path

# load optional app server dist entry script
# ==========================================
try require(appFilePath) app, opts
catch e
	if e.code and
		e.code.toLowerCase() is 'module_not_found' and
		e.message.indexOf(appFilePath) isnt -1
			console.log 'no app server scripts to load'
	else
		console.log e # log e if there is an actual error
