# Only for the build development
# ==============================
path = require 'path'
root = path.join __dirname, '..'
process.chdir root
q           = require 'q'
fs          = require 'fs'
changelog   = require 'conventional-changelog'
prependFile = require 'prepend-file'
file        = 'CHANGELOG.md'

# generators
# ==========
clearChangelog = ->
	fs.writeFileSync file, ''
	console.log 'Changelog cleared!'

recreateChangelog = (log, defer) ->
	fs.appendFile file, log, (e) ->
		console.log 'Changelog updated!'
		defer.resolve()

updateChangelog = (log, defer) ->
	prependFile file, log, (e) ->
		console.log 'Changelog updated!'
		defer.resolve()

# main
# ====
runChangelog = (recreate)  ->
	recreate = !!(recreate and recreate.toLowerCase() is 'recreate')
	defer    = q.defer()
	opts     = preset: 'angular'

	if recreate
		opts.releaseCount = 0
		clearChangelog()

	changelog opts
		.on 'data', (log) ->
			log = log.toString()
			log = log.replace /<a.*?<\/a>\n/g, '' # remove versionText anchor
			return updateChangelog log, defer unless recreate
			recreateChangelog log, defer

	defer.promise

# init
# ====
runChangelog process.argv[2]

