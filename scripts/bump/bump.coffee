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
			rb:      "#{rbRoot}/package.json"
			src:     "#{rbRoot}/src/src/server/package.json"
			test:    "#{rbRoot}/test/app/package.json"
			rbLock:  "#{rbRoot}/package-lock.json"
			srcLock: "#{rbRoot}/src/src/server/package-lock.json"

	pkgs =
		rb:      require paths.pkgs.rb
		src:     require paths.pkgs.src
		test:    require paths.pkgs.test
		rbLock:  require paths.pkgs.rbLock
		srcLock: require paths.pkgs.srcLock

	# tasks
	# =====
	tasks =
		bumpPkg: (pkgName, file) ->
			pkg     = pkgs[pkgName]
			pkgPath = paths.pkgs[pkgName]
			pkg.version = version
			fse.writeJsonAsync(pkgPath, pkg, jsonFormat).then ->
				console.log "bumped #{file}".info

		changelog: ->
			cmd = "coffee #{paths.changelog}"
			exec(cmd).then (result) ->
				console.log result.info

	# run tasks (in order)
	# ====================
	runTasks = async ->
		await tasks.bumpPkg 'rb',      'package.json'
		await tasks.bumpPkg 'rbLock',  'package-lock.json'
		await tasks.bumpPkg 'src',     'src server package.json'
		await tasks.bumpPkg 'srcLock', 'src server package-lock.json'
		await tasks.bumpPkg 'test',    'test package.json'
		await tasks.changelog()

	# run it!
	# =======
	runTasks()



