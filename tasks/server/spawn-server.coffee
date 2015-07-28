module.exports = (gulp, config) ->
	q            = require 'q'
	spawn        = require('child_process').spawn
	rbServerFile = config.dist.rb.server.scripts.path

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}spawn-server", ->
		defer  = q.defer()
		server = spawn 'node', [ rbServerFile ]
		server.stdout.on 'data', (data) ->
			msg = data.toString().trim()
			console.log msg.yellow
			defer.resolve() if msg.indexOf(config.server.msg.start) isnt -1
		defer.promise
