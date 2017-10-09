# ADD PROCESS ENV VARS
# ====================
module.exports = (config) ->
	# helpers
	# =======
	getOptions = ->
		opts = ''
		for own key, val of config.build.options
			continue unless val
			opts += "#{key}:"
		opts = opts.slice(0, -1) if opts.endsWith ':'
		opts

	# set
	# ===
	process.env.RB_LIB           = config.test.lib   # test lib or src | default is lib
	process.env.RB_MODE_OVERRIDE = config.build.mode # technique for running build tasks for specific modes
	process.env.RB_TEST          = true              # for testing app's gulpfile.js
	process.env.RB_TEST_OPTIONS  = getOptions()      # for testing app's build options
