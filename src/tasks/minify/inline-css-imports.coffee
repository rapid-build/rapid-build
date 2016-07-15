module.exports = (config, gulp) ->
	q        = require 'q'
	path     = require 'path'
	postcss  = require 'postcss'
	atImport = require 'postcss-import'
	log      = require "#{config.req.helpers}/log"

	# API
	# ===
	api =
		runTask: ->
			defer    = q.defer()
			ext      = '.css'
			fileName = path.basename config.fileName.styles.min, ext
			src      = config.temp.client.styles.dir
			src      = path.join src, "{#{fileName}#{ext},#{fileName}.*#{ext}}"
			dest     = config.temp.client.styles.dir
			minFile  = config.temp.client.styles.min.file
			opts     = root: config.dist.app.client.dir

			gulp.src src
				.on 'data', (file) ->
					css = file.contents
					return unless css
					css = css.toString()
					output =
						postcss()
							.use atImport opts
							.process css
							.css
					file.contents = new Buffer output
				.pipe gulp.dest dest
				.on 'end', ->
					log.task "inlined css imports in #{minFile}"
					defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()