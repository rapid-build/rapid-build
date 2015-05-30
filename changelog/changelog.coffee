# Only for rapid-build development
# ================================
process.chdir __dirname
q         = require 'q'
fs        = require 'fs'
path      = require 'path'
file      = {
				pkg:       path.join '..', 'package.json'
				changelog: path.join '..', 'CHANGELOG.md'
			}
pkg       = require file.pkg
changelog = require 'conventional-changelog'

runChangelog = ->
	defer = q.defer()
	opts =
		repository: pkg.repository.url
		version:    pkg.version
		file:       file.changelog
		# from:       'de5328d16019e214208f280105cddc75726dc3c0'
		# to:         '8fa1737ecb4d4bce2d4f6d09408aace851cab6fd'
	changelog opts, (e, log) ->
		fs.writeFile file.changelog, log, (e) ->
			console.log 'Here is your changelog!', log
			defer.resolve()
	defer.promise

# init
# ====
runChangelog()

