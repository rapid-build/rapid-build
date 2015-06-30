# FOR IE 9 AND BELOW - (for prod build, run against styles.min.css)
# Selector limit per stylesheet: 4,095
# Fortunately IE 10 ups the limit to: 65,534
# If you don't care about those piece of shit browsers, then disable this option.
# ===============================================================================
module.exports = (gulp, config) ->
	q     = require 'q'
	fs    = require 'fs'
	path  = require 'path'
	bless = require 'gulp-bless'

	# tasks
	# =====
	runTask = (src, dest, file, basename, ext) ->
		defer    = q.defer()
		opts     = imports:false, force:true
		cnt      = 1
		didSplit = false
		gulp.src src
			.pipe bless opts
			.on 'data', (_file) -> # change the name so the glob order will be correct
				isBlessedFile = _file.basename.indexOf('blessed') isnt -1
				didSplit      = isBlessedFile or cnt > 1
				return unless didSplit
				fs.unlinkSync _file.path unless isBlessedFile # remove styles.min.css
				_file.basename = "#{basename}.#{cnt}.#{ext}"
				cnt++ if isBlessedFile
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "#{file} split into #{cnt} files".yellow if didSplit
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}css-file-split", ->
		stylesDir = config.dist.app.client.styles.dir
		minFile   = config.fileName.styles.min
		minPath   = path.join stylesDir, minFile
		ext       = 'css'
		basename  = path.basename minFile, ".#{ext}"
		runTask minPath, stylesDir, minFile, basename, ext


