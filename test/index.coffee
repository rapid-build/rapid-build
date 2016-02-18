configX = require('../core/config')()
# console.log config
# console.log config.paths.abs.root
# console.log config.paths.abs.test.path
return

# requires
# ========
q      = require 'q'
path   = require 'path'
gWatch = require 'gulp-watch'

# vars
# ====
dir     = __dirname
rootDir = path.dirname dir
argv    = process.argv
isDev   = !!argv[2] && argv[2].toLowerCase() is 'dev'

# config req
# ==========
config =
	req:
		rb:           rootDir
		helpers:      path.join rootDir, 'helpers'
		jasmine:      path.join dir,     'jasmine'
		tests:        path.join dir,     'tests'
		node_modules: path.join rootDir, 'node_modules'

# config node_modules
# ===================
config.node_modules =
	'jasmine-expect': path.join 'node_modules', 'jasmine-expect'

# console.log 'config', config

# test files
# ==========
tests = path.relative config.req.rb, config.req.tests
tests = path.join tests, '**', '*.*'

# run tests
# =========
jasmine = require('./framework/jasmine') config
jasmine.init(tests).execute()
# console.log 'jasmine',  jasmine

# DEV
# ===
return unless isDev
testsDir = path.relative config.req.rb, config.req.tests
testGlob = path.join config.req.tests, '**', '*.*'

# watches
# =======
createWatch = (glob) ->
	defer = q.defer()
	gWatch glob, read:false, (file) ->
		test = path.join testsDir, file.relative
		# console.log "test: #{test}".cyan
		jasmine.init(test).reExecute()
	.on 'ready', ->
		console.log "watching tests".yellow
		defer.resolve()
	defer.promise

createWatch testGlob


