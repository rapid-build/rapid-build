# bootstrap
# =========
module.exports = ->
	colors = require 'colors'
	colors.setTheme
		alert:   'yellow'
		error:   ['red', 'bold']
		info:    'cyan'
		success: ['green', 'bold']
	colors