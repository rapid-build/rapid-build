# BUMP VERSIONS THEN RUN CHANGELOG
# ================================
module.exports = (rbRoot, version) ->
	async      = require 'asyncawait/async'
	await      = require 'asyncawait/await'
	Promise    = require 'bluebird'
	fse        = Promise.promisifyAll require 'fs-extra'
	exec       = Promise.promisify require('child_process').exec
	jsonFormat = spaces: '\t'

	paths =
		changelog: "#{rbRoot}/changelog/changelog.coffee"
		pkgs:
			rb:   "#{rbRoot}/package.json"
			test: "#{rbRoot}/test/app/package.json"

	pkgs =
		rb:   require paths.pkgs.rb
		test: require paths.pkgs.test

	# tasks
	# =====
	tasks =
		bumpPkg: (pkgName) ->
			pkg     = pkgs[pkgName]
			pkgPath = paths.pkgs[pkgName]
			pkg.version = version
			fse.writeJsonAsync(pkgPath, pkg, jsonFormat).then ->
				console.log "bumped #{pkgName}'s package.json".info

		changelog: ->
			cmd = "coffee #{paths.changelog}"
			exec(cmd).then (result) ->
				console.log result.info

	# run tasks (in order)
	# ====================
	runTasks = async ->
		await tasks.bumpPkg 'rb'
		await tasks.bumpPkg 'test'
		await tasks.changelog()

	# run it!
	# =======
	runTasks()



