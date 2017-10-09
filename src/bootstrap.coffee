# build bootstrap
# ===============
module.exports = ->
	colors = require 'colors'
	colors.setTheme
		alert:   'yellow'
		attn:    ['cyan', 'bold']
		error:   ['red', 'bold']
		info:    'cyan'
		minor:   'gray'
		success: ['green', 'bold']
		warn:    'magenta'
	colors