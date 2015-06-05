module.exports = (gulp, config) ->
	q   = require 'q'

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
		rbImgDest = config.temp.client.dir   + '/' +
					config.rb.prefix.distDir + '/' +
					config.dist.rb.client.images.dirName
		moveTask(
			"#{config.glob.dist.rb.client.images.all}/*"
			rbImgDest
		)


