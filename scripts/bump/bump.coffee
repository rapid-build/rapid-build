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
			docs: "#{rbRoot}/docs/package.json"
			test: "#{rbRoot}/test/app/package.json"
		files:
			docsConst: "#{rbRoot}/docs/src/client/scripts/constants/rb-constant.coffee"

	pkgs =
		rb:   require paths.pkgs.rb
		docs: require paths.pkgs.docs
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

		bumpDocsConst: ->
			promise = fse.readFileAsync paths.files.docsConst
			promise.then (data) ->
				needle       = "'"
				contents     = data.toString()
				index1       = contents.lastIndexOf needle
				index2       = contents.lastIndexOf needle, index1 - 1
				constVersion = contents.substring index2 + 1, index1
				contents     = contents.replace constVersion, version
				fse.outputFileAsync(paths.files.docsConst, contents).then ->
					console.log "bumped doc's version constant file".info

		changelog: ->
			cmd = "coffee #{paths.changelog}"
			exec(cmd).then (result) ->
				console.log result.info

	# run tasks (in order)
	# ====================
	runTasks = async ->
		await tasks.bumpPkg 'rb'
		await tasks.bumpPkg 'test'
		await tasks.bumpPkg 'docs'
		await tasks.bumpDocsConst 'docs'
		await tasks.changelog()

	# run it!
	# =======
	runTasks()



