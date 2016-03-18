# CONFIG: BUILD
# Mode Options:
#   ''   | default
#   test | test:client | test:server
#   dev  | dev:test    | dev:test:client  | dev:test:server
#   prod | prod:test   | prod:test:client | prod:test:server | prod:server
# ========================================================================
module.exports = (config, opts=[]) ->
	# int build
	# =========
	build =
		mode: ''
		options: null

	# helpers
	# =======
	getMode = ->
		mode = build.mode
		for opt in opts
			continue if opt.indexOf('options') isnt -1
			continue if opt.indexOf('verbose') isnt -1 # test reporter
			continue if opt.indexOf('watch') isnt -1   # watching tests
			mode = opt; break
		mode

	getOptions = ->
		bOpts = build.options
		for opt in opts
			continue if opt.indexOf('options:') is -1
			bOpts = opt.split(':')[1]; break
		bOpts

	# set
	# ===
	build.mode    = getMode()
	build.options = getOptions()

	# add and return
	# ==============
	config.build = build
	config



