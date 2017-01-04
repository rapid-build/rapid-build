# PREP API OPTIONS
# ================
module.exports = (config, options) ->
	log = require "#{config.req.helpers}/log"

	# format options
	# ==============
	options = require("#{config.req.config.options}/option-build")        config, options
	options = require("#{config.req.config.options}/option-compile")      config, options
	options = require("#{config.req.config.options}/option-dist-and-src") config, options
	options = require("#{config.req.config.options}/option-ports")        config, options
	options = require("#{config.req.config.options}/option-order")        config, options
	options = require("#{config.req.config.options}/option-angular")      config, options
	options = require("#{config.req.config.options}/option-spa")          config, options
	options = require("#{config.req.config.options}/option-minify")       config, options
	options = require("#{config.req.config.options}/option-exclude")      config, options
	options = require("#{config.req.config.options}/option-test")         config, options
	options = require("#{config.req.config.options}/option-http-proxy")   config, options
	options = require("#{config.req.config.options}/option-browser")      config, options
	options = require("#{config.req.config.options}/option-extra")        config, options
	options = require("#{config.req.config.options}/option-security")     config, options

	# logs
	# ====
	# log.json options, 'options ='

	# return
	# ======
	options

