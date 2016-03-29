# requires
# ========
fse    = require 'fs-extra'
path   = require 'path'
tasks  = '../../tasks'
config = require("#{tasks}/get-config")()
require("#{tasks}/add-colors")()

# constants
# =========
TEMP_PATH         = config.paths.abs.extra.temp
CSS_DIR           = path.basename __dirname
CSS_DEST_PATH     = path.join TEMP_PATH, CSS_DIR, 'selectors.css'
CSS_DEST_PATH_REL = path.relative "#{TEMP_PATH}/../..", CSS_DEST_PATH
CSS_DEST_PATH_REL = path.normalize "/#{CSS_DEST_PATH_REL}"

# Colors
# ======
class Colors
	_total     = null
	_colors    = null
	_selectors = null

	constructor: (colors...) ->
		_total     = 4095
		_colors    = {}
		_selectors = {}
		@setColors colors

	setColors: (colors) ->
		for color, i in colors
			_colors[color] =
				name:  color
				start: _colors[colors[i-1]]?.end + 1 or 1
				end:   _colors[colors[i-1]]?.end + _total or _total
		@

	setSelectors: (unique=true) ->
		id  = ''
		cnt = 1
		for k, v of _colors
			string = ''
			while cnt <= v.end
				id     = cnt if unique
				string += "#test#{id} { background-color: #{k}; }"
				string += '\n' if cnt isnt v.end
				cnt++
			_selectors[k] = string
		@

	getSelectors: ->
		cnt    = 0
		string = ''
		for k, v of _selectors
			string += '\n' if cnt
			cnt++
			string += v
		string

# init
# ====
selectors = new Colors('blue','gray').setSelectors().getSelectors()
fse.outputFile CSS_DEST_PATH, selectors, (e) ->
	return console.log e if e
	console.log "created: #{CSS_DEST_PATH_REL}".info

