# FOR THE PROD BUILD
# ==================
module.exports = (config) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# constants
	# =========
	tDir     = '.temp'
	glob     = '/**/*'
	types    = ['scripts', 'styles']
	rbAndApp = ['rb', 'app']

	# init temp
	# =========
	temp = {}
	temp.client = {}
	temp.client.dir  = path.join config.dist.app.client.dir, tDir
	temp.client.glob = path.join temp.client.dir, glob

	# add types
	# =========
	addTypes = ->
		for own k1, v1 of config.fileName
			continue if types.indexOf(k1) is -1
			temp.client[k1] = {}
			temp.client[k1].dir  = path.join temp.client.dir, config.dist.app.client[k1].dirName
			temp.client[k1].glob = path.join temp.client[k1].dir, glob
			for own k2, v2 of v1
				continue if k2 isnt 'min'
				temp.client[k1][k2] = {}
				temp.client[k1][k2].file = v2
				temp.client[k1][k2].path = path.join temp.client[k1].dir, temp.client[k1][k2].file

	addTypesRbAndApp = ->
		for own k1, v1 of config.fileName
			continue if types.indexOf(k1) is -1
			rbAndApp.forEach (appOrRb) ->
				typeDir = temp.client[k1].dir
				temp.client[k1][appOrRb] = {}
				temp.client[k1][appOrRb].dir = path.join typeDir, appOrRb

	# build types (in order)
	# ======================
	addTypes()
	addTypesRbAndApp()

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



