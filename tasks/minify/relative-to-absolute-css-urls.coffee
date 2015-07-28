module.exports = (gulp, config) ->
	q        = require 'q'
	path     = require 'path'
	pathHelp = require "#{config.req.helpers}/path"
	urlRegex = /url\s*\(\s*['"]?([^\/].*?)['"]?\s*\)/g

	# helpers
	# =======
	# replace relative urls with absolute urls
	replaceCssUrls = (css, fileDir, clientDist) ->
		css = css.replace urlRegex, (match, urlPath) ->
			first      = urlPath[0]
			second     = urlPath[1]
			first2     = first + second
			isExternal = urlPath.toLowerCase().indexOf('//') isnt -1 # like from http
			if first2 isnt "'/" and first2 isnt '"/' and not isExternal
				_path = path.resolve fileDir, urlPath
				_path = pathHelp.format _path
				_path = _path.replace clientDist, ''
				_path = "#{_path}"
			else
				_path = urlPath
			url = _path.replace(/'/g,'').replace(/"/g,'')
			url = "url('#{url}')"
			url
		css

	# tasks
	# =====
	cssUrlSwap = (appOrRb, type, glob='css') ->
		defer      = q.defer()
		src        = config.glob.dist[appOrRb].client[type][glob]
		dest       = config.dist[appOrRb].client[type].dir
		clientDist = path.join config.app.dir, config.dist.app.client.dir
		clientDist = pathHelp.format clientDist
		gulp.src src
			.on 'data', (file) ->
				return if file.isNull()
				css      = file.contents.toString()
				fileDir  = path.dirname file.path
				fileDir  = pathHelp.format fileDir
				css      = replaceCssUrls css, fileDir, clientDist
				file.contents = new Buffer css
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve()
		defer.promise

	runTasks = ->
		defer = q.defer()
		q.all([
			cssUrlSwap 'rb',  'bower'
			cssUrlSwap 'rb',  'libs'
			cssUrlSwap 'rb',  'styles', 'all'
			cssUrlSwap 'app', 'bower'
			cssUrlSwap 'app', 'libs'
		]).done ->
			console.log 'changed libs and bower_components css urls from relative to absolute'.yellow
			defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}relative-to-absolute-css-urls", ->
		runTasks()