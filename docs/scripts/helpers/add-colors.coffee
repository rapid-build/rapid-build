# ADD COLORS
# ==========
module.exports = ->
	colors = require 'colors'
	colors.setTheme
		alert:   'yellow'
		attn:    ['cyan', 'bold']
		error:   ['red', 'bold']
		info:    'cyan'
		success: ['green', 'bold']
	colors