dir           = __dirname # all paths are relative to this file
path          = require 'path'
express       = require 'express'
bodyParser    = require 'body-parser'
config        = require path.join dir, 'config.json'
app           = express()
port          = process.env.PORT or config.ports.server
spa           = config.spa.dist.file # ex: spa.html
clientDirPath = path.resolve dir, '..', '..', config.dist.app.client.dirName # creates absolute path to the client folder
appFilePath   = path.resolve dir, '..', config.dist.app.server.scripts.file
serverDirPath = path.resolve dir, '..', '..', config.dist.app.server.dirName
proxyFilePath = path.join dir, 'http-proxy.js'

# configure
# =========
app.use express.static clientDirPath
app.use bodyParser.json() # parse application/json

app.listen port, ->
	console.log "#{config.server.msg.start} #{config.ports.server}"

app.get '/', (req, res) ->
	msg = 'Hello Server!'
	return res.send msg unless config.build.client
	return res.send msg if config.exclude.spa
	res.sendFile spa, root: clientDirPath

# options to pass
# ===============
opts =
	path:
		client: clientDirPath
		server: serverDirPath

# load optional http proxy
# ========================
require(proxyFilePath) app, config, opts if config.httpProxy.length

# load optional app server dist entry script
# ==========================================
try require(appFilePath) app, opts
catch e
	if e.code and
		e.code.toLowerCase() is 'module_not_found' and
		e.message.indexOf(appFilePath) isnt -1
			console.log config.server.msg.noScripts
	else
		console.log e # log e if there is an actual error
