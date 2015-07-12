# FOR IE 9 AND BELOW - (for prod build, run against styles.min.css)
# Selector limit per stylesheet: 4,095
# Fortunately IE 10 ups the limit to: 65,534
# If you don't care about those piece of shit browsers, then disable this option.
# ===============================================================================
module.exports = (gulp, config) ->
	q           = require 'q'
	fs          = require 'fs'
	path        = require 'path'
	bless       = require 'gulp-bless'
	promiseHelp = require "#{config.req.helpers}/promise"

	# tasks
	# =====
	runTask = (src, dest, ext) ->
		defer    = q.defer()
		opts     = imports:false, force:true
		files    = []
		gulp.src src
			.on 'data', (file) ->
				basename = path.basename file.path
				files.push name: basename, cnt: 0
			.pipe bless opts
			.on 'data', (file) -> # change the name so the glob order will be correct
				total         = files.length
				basename      = file.basename
				return unless total
				return unless basename
				_file         = files[total-1]
				isBlessedFile = basename.indexOf('blessed') isnt -1
				didSplit      = isBlessedFile or _file.cnt
				return unless didSplit
				fs.unlinkSync file.path unless isBlessedFile # remove styles.min.css
				_file.cnt++
				basename      = path.basename _file.name, ext
				file.basename = "#{basename}.#{_file.cnt}#{ext}"
			.pipe gulp.dest dest
			.on 'end', ->
				for file in files
					console.log "#{file.name} split into #{file.cnt} files".yellow if file.cnt
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}css-file-split", ->
		return promiseHelp.get() if not config.minify.css.splitMinFile
		ext  = '.css'
		dest = config.dist.app.client.styles.dir
		src  = path.join dest, "{styles.min#{ext},styles.min.*#{ext}}"
		runTask src, dest, ext


