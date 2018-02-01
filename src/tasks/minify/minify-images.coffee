# todo: actually minify the images
# ================================
module.exports = (config, gulp, Task) ->
	q    = require 'q'
	path = require 'path'

	moveTask = (src, dest) -> # move to rb .temp folder
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				message = "completed: copied images from .temp directory"
				defer.resolve { message }
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
			moveTask(src, dest).then ->
				# log: 'minor'
				message: "minified images in: #{config.dist.app.client.dir}"

	# return
	# ======
	api.runTask()



