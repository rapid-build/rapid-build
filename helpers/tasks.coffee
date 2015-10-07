module.exports = (config, gulp={}) ->
	q      = require 'q'
	isType = require "#{config.req.helpers}/isType"

	# private
	# =======
	getTasks = (tasksCb, type, lang, locs) ->
		tasks = []
		locs.forEach (v1) ->
			['rb','app'].forEach (v2) ->
				tasks.push
					src:  config.glob.src[v2][v1][type][lang]
					dest: config.dist[v2][v1][type].dir
		tasks.forEach (v, i) ->
			tasks[i] = -> tasksCb v.src, v.dest
		tasks

	prefixTaskDeps = (deps) ->
		deps = (dep = "#{config.rb.prefix.task}#{dep}" for dep in deps)
		deps

	getTaskDeps = (deps=[]) ->
		return [] unless deps.length
		deps = prefixTaskDeps deps
		deps

	# public
	# ======
	run:
		async: (tasksCb, type, lang, locs) ->
			tasks    = getTasks tasksCb, type, lang, locs
			defer    = q.defer()
			promises = tasks.map (task) -> task()
			q.all(promises).done -> defer.resolve()
			defer.promise

		sync: (tasksCb, type, lang, locs) ->
			tasks = getTasks tasksCb, type, lang, locs
			defer = q.defer()
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	wasCalledFrom: (taskName) -> # return boolean
		calledFromTask = gulp.seq.indexOf(taskName) isnt -1
		# console.log "was called from task #{taskName} = #{calledFromTask}".yellow
		calledFromTask

	startTask: (taskName) ->
		# ALERT: gulp.start is supposedly going away in gulp 4
		gulp.start "#{config.rb.prefix.task}#{taskName}"

	addTask: (taskName, _path, opts={}) -> # very important method
		deps = getTaskDeps opts.deps

		gulp.task "#{config.rb.prefix.task}#{taskName}", deps, (cb) ->
			task = require "#{config.req.tasks}#{_path}"
			opts.taskCB = cb if opts.taskCB

			return task config, gulp, opts if isType.function task
			task[opts.run] config, gulp, opts # task is an object



