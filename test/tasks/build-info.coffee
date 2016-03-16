# BUILD INFO
# Mode Options:
#   ''   | default
#   test | test:client | test:server
#   dev  | dev:test    | dev:test:client  | dev:test:server
#   prod | prod:test   | prod:test:client | prod:test:server | prod:server
# ========================================================================
module.exports = (argv) ->
	# build defaults
	# ==============
	build =
		mode:       ''
		options:    null
		watchTests: false

	# vars
	# ====
	opts = argv.slice 2
	opts = (opt.toLowerCase() for opt in opts) # prep work

	# helpers
	# =======
	getMode = ->
		mode = build.mode
		for opt in opts
			continue if opt.indexOf('watch') isnt -1
			continue if opt.indexOf('options') isnt -1
			mode = opt; break
		mode

	getOptions = ->
		bOpts = build.options
		for opt in opts
			continue if opt.indexOf('options') is -1
			bOpts = opt.split(':')[1]; break
		bOpts

	getWatchTests = ->
		opts.indexOf('watch') isnt -1

	# set
	# ===
	return build unless opts.length
	build.mode       = getMode()
	build.options    = getOptions()
	build.watchTests = getWatchTests()

	# return
	# ======
	build