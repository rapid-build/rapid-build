# CONFIG: TEST
# ============
module.exports = (config, opts=[]) ->
	# int test
	# ========
	test =
		lib: 'lib'
		watch: false
		verbose:
			tasks:     false
			jasmine:   false
			processes: false

	# helpers
	# =======
	getLib = ->
		lib = test.lib
		for opt in opts
			continue if opt.indexOf('lib') is -1
			ops = opt.split ':'
			break if ops[0] is 'lib' and ops.length is 1
			if ops.indexOf('src') isnt -1 then lib = 'src'
			break
		lib

	getWatch = ->
		opts.indexOf('watch') isnt -1

	getVerbose = ->
		vOpts = test.verbose
		for opt in opts
			continue if opt.indexOf('verbose') is -1
			vb = opt.split ':'
			if vb[0] is 'verbose' and vb.length is 1 then vOpts.jasmine = true; break
			if vb.indexOf('*')         isnt -1 then vOpts = tasks:true, jasmine:true, processes:true; break
			if vb.indexOf('tasks')     isnt -1 then vOpts.tasks     = true
			if vb.indexOf('jasmine')   isnt -1 then vOpts.jasmine   = true
			if vb.indexOf('processes') isnt -1 then vOpts.processes = true
			break
		vOpts

	# set
	# ===
	test.lib     = getLib()
	test.watch   = getWatch()
	test.verbose = getVerbose()

	# add and return
	# ==============
	config.test = test
	config



