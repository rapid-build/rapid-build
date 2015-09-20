# rapid config
# ============
module.exports = (rbDir, options) ->
	# init config
	# ===========
	config = {}
	config.env = {} # declare here so it will show up first

	# get config in order
	# ===================
	config  = require("#{rbDir}/config/config-req")               config, rbDir
	options = require("#{config.req.config}/config-options")      config, options
	config  = require("#{config.req.config}/config-env")          config
	config  = require("#{config.req.config}/config-rb")           config, rbDir
	config  = require("#{config.req.config}/config-app")          config, options
	config  = require("#{config.req.config}/config-ports")        config, options
	config  = require("#{config.req.config}/config-server")       config
	config  = require("#{config.req.config}/config-file-names")   config
	config  = require("#{config.req.config}/config-minify")       config, options
	config  = require("#{config.req.config}/config-dist-and-src") config, options
	config  = require("#{config.req.config}/config-angular")      config, options
	config  = require("#{config.req.config}/config-spa")          config, options
	config  = require("#{config.req.config}/config-exclude")      config, options
	config  = require("#{config.req.config}/config-extra")        config
	config  = require("#{config.req.config}/config-extra-copy")   config, options
	config  = require("#{config.req.config}/config-templates")    config
	config  = require("#{config.req.config}/config-temp")         config
	config  = require("#{config.req.config}/config-http-proxy")   config, options
	config  = require("#{config.req.config}/config-node_modules") config, options
	config  = require("#{config.req.config}/config-order")        config, options
	config  = require("#{config.req.config}/config-globs")        config
	config  = require("#{config.req.config}/config-bower")        config, options
	config  = require("#{config.req.config}/config-test")         config, options
	config  = require("#{config.req.config}/config-internal")     config

	# format
	# ======
	req = config.req
	delete config.req # so req will show up last
	config.req = req

	# return
	# ======
	config


