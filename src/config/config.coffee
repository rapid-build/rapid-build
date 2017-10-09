# build config
# ============
module.exports = (rbDir, options) ->
	# init config
	# ===========
	config = {}
	config.env = {} # declare here so it will show up first

	# get config in order
	# ===================
	config  = require("#{rbDir}/config/configs/config-req")                config, rbDir
	options = require("#{config.req.config.path}/config-options")          config, options
	config  = require("#{config.req.config.configs}/config-rb")            config, rbDir
	config  = require("#{config.req.config.configs}/config-app")           config, options
	config  = require("#{config.req.config.configs}/config-env")           config
	config  = require("#{config.req.config.configs}/config-generated")     config
	config  = require("#{config.req.config.configs}/config-build")         config, options
	config  = require("#{config.req.config.configs}/config-ports")         config, options
	config  = require("#{config.req.config.configs}/config-browser")       config, options
	config  = require("#{config.req.config.configs}/config-minify")        config, options
	config  = require("#{config.req.config.configs}/config-file-names")    config
	config  = require("#{config.req.config.configs}/config-security")      config, options
	config  = require("#{config.req.config.configs}/config-dist-and-src")  config, options
	config  = require("#{config.req.config.configs}/config-angular")       config, options
	config  = require("#{config.req.config.configs}/config-spa")           config, options
	config  = require("#{config.req.config.configs}/config-exclude")       config, options
	config  = require("#{config.req.config.configs}/config-compile")       config, options
	config  = require("#{config.req.config.configs}/config-extra")         config
	config  = require("#{config.req.config.configs}/config-extra-copy")    config, options
	config  = require("#{config.req.config.configs}/config-extra-compile") config, options
	config  = require("#{config.req.config.configs}/config-extra-minify")  config, options
	config  = require("#{config.req.config.configs}/config-templates")     config
	config  = require("#{config.req.config.configs}/config-temp")          config
	config  = require("#{config.req.config.configs}/config-http-proxy")    config, options
	config  = require("#{config.req.config.configs}/config-order")         config, options
	config  = require("#{config.req.config.configs}/config-globs")         config
	config  = require("#{config.req.config.configs}/config-bower")         config, options
	config  = require("#{config.req.config.configs}/config-test")          config, options
	config  = require("#{config.req.config.configs}/config-internal")      config

	# format
	# ======
	req = config.req
	delete config.req # so req will show up last
	config.req = req

	# return
	# ======
	config


