# todo: actually minify the images
# ================================
module.exports = (config, gulp) ->
	q    = require 'q'
	path = require 'path'

	moveTask = (src, dest) -> # move to rb .temp folder
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "copied rb images".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			src  = "#{config.glob.dist.rb.client.images.all}/*"
			dest = path.join(
						config.temp.client.dir
						config.rb.prefix.distDir
						config.dist.rb.client.images.dirName
					)
			moveTask src, dest

	# return
	# ======
	api.runTask()



