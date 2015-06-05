module.exports = (config) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# constants
	# =========
	tDir  = '.temp'
	types = ['scripts', 'styles']
	files = ['all', 'min']

	# init temp
	# =========
	temp = {}
	temp.client = {}
	temp.client.dir = path.join config.dist.app.client.dir, tDir

	# add types
	# =========
	addTypes = ->
		for own k1, v1 of config.fileName
			continue if types.indexOf(k1) is -1
			temp.client[k1] = {}
			temp.client[k1].dir =
				path.join temp.client.dir,
						  config.dist.app.client[k1].dirName
			for own k2, v2 of v1
				continue if files.indexOf(k2) is -1
				temp.client[k1][k2] = {}
				temp.client[k1][k2].file = v2
				temp.client[k1][k2].path =
					path.join temp.client[k1].dir,
							  temp.client[k1][k2].file
	addTypes()

	# add temp to config
	# ===================
	config.temp = temp

	# logs
	# ====
	# log.json temp, 'temp ='

	# tests
	# =====
	test.log 'true', config.temp, 'add temp to config'

	# return
	# ======
	config



