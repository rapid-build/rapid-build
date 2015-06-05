# rapid config
# ============
module.exports = (rbDir, options) ->
	# init config
	# ===========
	config = {}
	config.env = {} # declare here so it will show up first

	# require
	# =======
	req =
		rb:      rbDir
		config:  "#{rbDir}/config"
		files:   "#{rbDir}/files"
		helpers: "#{rbDir}/helpers"
		init:    "#{rbDir}/init"
		tasks:   "#{rbDir}/tasks"

	config.req = req

	# get config in order
	# ===================
	options = require("#{config.req.config}/config-options")      config, options
	config  = require("#{config.req.config}/config-env")          config
	config  = require("#{config.req.config}/config-rb")           config, rbDir
	config  = require("#{config.req.config}/config-app")          config, options
	config  = require("#{config.req.config}/config-file-names")   config
	config  = require("#{config.req.config}/config-dist-and-src") config, options
	config  = require("#{config.req.config}/config-temp")         config
	config  = require("#{config.req.config}/config-node_modules") config
	config  = require("#{config.req.config}/config-angular")      config, options
	config  = require("#{config.req.config}/config-order")        config, options
	config  = require("#{config.req.config}/config-globs")        config
	config  = require("#{config.req.config}/config-json")         config
	config  = require("#{config.req.config}/config-bower")        config, options

	# format
	# ======
	delete config.req # so req will show up last
	config.req = req

	# return
	# ======
	config


