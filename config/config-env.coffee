module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init env
	# ========
	env = {}
	env.name = 'default'
	env.set = (gulp) -> # called in "#{config.rb.prefix.task}common"
		switch gulp.seq[1]
			when config.rb.tasks.dev  then config.env.name = 'dev'
			when config.rb.tasks.prod then config.env.name = 'prod'

	# add env to config
	# =================
	config.env = env

	# logs
	# ====
	# log.json env, 'env ='

	# tests
	# =====
	test.log 'true', config.env, 'add env to config'

	# return
	# ======
	config


