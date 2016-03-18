# CONFIG: TEST
# ============
module.exports = (config, opts=[]) ->
	# int test
	# ========
	test =
		watch:   false
		verbose: false

	# helpers
	# =======
	getWatch = ->
		opts.indexOf('watch') isnt -1

	getVerbose = ->
		opts.indexOf('verbose') isnt -1

	# set
	# ===
	test.watch   = getWatch()
	test.verbose = getVerbose()

	# add and return
	# ==============
	config.test = test
	config



