dir           = __dirname # all paths are relative to this file
path          = require 'path'
express       = require 'express'
bodyParser    = require 'body-parser' # middleware for parsing the req.body
config        = require path.join dir, 'config.json'
appFilePath   = path.resolve dir, '..', config.dist.app.server.scripts.file
clientDirPath = path.resolve dir, '..', '..', config.dist.app.client.dirName # creates absolute path to the client folder
serverDirPath = path.resolve dir, '..', '..', config.dist.app.server.dirName

# create the server object
# ========================
server = require './server'
server.express    = express
server.app        = server.express()
server.middleware = { bodyParser }
server.paths      = client: clientDirPath, server: serverDirPath
server.server     = require('./start-server') server.app, config
require('./app-defaults') server, config

# load optional http proxy
# ========================
proxyFilePath = path.join dir, 'http-proxy.js'
require(proxyFilePath) server.app, config if config.httpProxy.length

# load optional app server dist entry script
# ==========================================
try require(appFilePath) server
catch e
	if e.code and
		e.code.toLowerCase() is 'module_not_found' and
		e.message.indexOf(appFilePath) isnt -1
			console.log 'No application server scripts to load.'
	else
		console.log e # log e if there is an actual error


