module.exports = ->
	path       = require 'path'
	conditions = ['false', 'true']

	getFromFile = ->
		ext = path.extname module.parent.filename
		path.basename module.parent.filename, ext

	# API
	# ===
	false: (from, condition, v, msg) ->
		return if !v
		msg = msg or "#{condition} test failed"
		console.error "ERROR #{from}: #{msg}".error

	true: (from, condition, v, msg) ->
		return if !!v
		msg = msg or "#{condition} test failed"
		console.error "ERROR #{from}: #{msg}".error

	log: (condition, v, msg) ->
		from = "(#{getFromFile()})"
		return if conditions.indexOf(condition) is -1
			console.error(
				"ERROR #{from}: \"#{condition}\" is
				not a supported test condition".error
			)

		@[condition] from, condition, v, msg