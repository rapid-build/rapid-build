fs = require 'fs'

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

selectors = new Colors('blue','gray').setSelectors().getSelectors()
fs.writeFile 'selectors.css', selectors