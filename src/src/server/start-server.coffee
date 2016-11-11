dir           = __dirname # all paths are relative to this file
path          = require 'path'
express       = require 'express'
bodyParser    = require 'body-parser' # middleware for parsing the req.body
config        = require path.join dir, 'config.json'
appFilePath   = path.resolve dir, '..', config.dist.app.server.scripts.file
clientDirPath = path.resolve dir, '..', '..', config.dist.app.client.dirName # creates absolute path to the client folder
serverDirPath = path.resolve dir, '..', '..', config.dist.app.server.dirName

# set NODE_ENV (conditionally)
# ============================
process.env.NODE_ENV = 'production' if config.env.is.prod

# create the server object
# ========================
server = {}
server.express    = express
server.app        = server.express()
server.middleware = {}
server.paths      = client: clientDirPath, server: serverDirPath
server.server     = require('./defaults/app-listener') server, config

# load default settings
# =====================
require('./defaults/app-settings') server, config

# load optional http proxy middleware (must go before bodyParser)
# ===================================
if config.httpProxy.length
	proxyFilePath = path.join dir, 'options', 'http-proxy.js'
	httpProxy     = require(proxyFilePath) server.app, config
	server.middleware.httpProxy = httpProxy

# load default middleware
# =======================
server.middleware.bodyParser = bodyParser
require('./defaults/app-middleware') server, config

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

# load default app configuration
# ==============================
require('./defaults/app-static-files-dir') server, config
require('./defaults/app-routes') server, config

# run tasks
# =========
require('./tasks/build-server-info') server

