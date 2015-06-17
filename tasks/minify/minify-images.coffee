module.exports = (gulp, config) ->
	q    = require 'q'
	path = require 'path'

	moveTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "copied rb images".yellow
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-images", ->
		src  = "#{config.glob.dist.rb.client.images.all}/*"
		dest = path.join(
					config.temp.client.dir
					config.rb.prefix.distDir
					config.dist.rb.client.images.dirName
				)
		moveTask src, dest


