# CONFIG: BUILD
# Options:
#   Mode:
#     ''   | default
#     test | test:client | test:server
#     dev  | dev:test    | dev:test:client  | dev:test:server
#     prod | prod:test   | prod:test:client | prod:test:server | prod:server
#   Options (prepend "options:"):
#     * (run all options)
#     angular | browser   | build  | dist  | exclude
#     extra   | httpProxy | minify | ports | order
#     server  | spa       | src    | test
# ========================================================================
module.exports = (config, opts=[]) ->
	# int build
	# =========
	build =
		mode: ''
		options:
			angular:   false
			browser:   false
			build:     false
			dist:      false
			exclude:   false
			extra:     false
			httpProxy: false
			minify:    false
			ports:     false
			order:     false
			server:    false
			spa:       false
			src:       false
			test:      false

	# helpers
	# =======
	getMode = ->
		mode = build.mode
		for opt in opts
			continue if opt.indexOf('options') isnt -1
			continue if opt.indexOf('verbose') isnt -1 # test reporter
			continue if opt.indexOf('watch')   isnt -1 # watching tests
			mode = opt; break
		mode

	getOptions = ->
		bOpts = build.options
		for opt in opts
			continue if opt.indexOf('options:') is -1
			bo = opt.split ':'
			continue if bo[0] isnt 'options'
			break unless bo[1]
			bo  = bo.slice 1 # remove options
			all = bo.indexOf('*') isnt -1
			bo  = Object.keys bOpts if all
			for v in bo
				bOpts[v] = true
			break
		bOpts

	# set
	# ===
	build.mode    = getMode()
	build.options = getOptions()

	# add and return
	# ==============
	config.build = build
	config



