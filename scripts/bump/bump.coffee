# BUMP VERSIONS THEN RUN CHANGELOG
# ================================
module.exports = (rbRoot, version) ->
	q          = require 'q'
	fse        = require 'fs-extra'
	execSync   = require('child_process').execSync
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
	api =
		bumpPkg: (pkgName, file) ->
			pkg     = pkgs[pkgName]
			pkgPath = paths.pkgs[pkgName]
			pkg.version = version
			fse.writeJson(pkgPath, pkg, jsonFormat).then ->
				console.log "bumped #{file}".info

		changelog: ->
			cmd = "coffee #{paths.changelog}"
			try stdout = execSync cmd
			catch e then throw e
			msg = stdout.toString()
			console.log msg.info
			q msg

	# run tasks (in order)
	# ====================
	runTasks = -> # sync
		defer = q.defer()
		tasks = [
			-> api.bumpPkg 'rb',      'package.json'
			-> api.bumpPkg 'rbLock',  'package-lock.json'
			-> api.bumpPkg 'src',     'src server package.json'
			-> api.bumpPkg 'srcLock', 'src server package-lock.json'
			-> api.bumpPkg 'test',    'test package.json'
			-> api.changelog()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# run it!
	# =======
	runTasks()



