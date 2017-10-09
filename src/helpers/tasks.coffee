module.exports = (config, gulp={}) ->
	q      = require 'q'
	isType = require "#{config.req.helpers}/isType"

	# private
	# =======
	addedTaskCB = (_path, cb, opts) ->
		opts.taskCB = cb if opts.taskCB
		api.startTask _path, opts

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

	prefixTask = (taskName) ->
		config.rb.prefix.task + taskName

	prefixTaskDeps = (deps) ->
		deps = (prefixTask dep for dep in deps)

	getTaskDeps = (deps=[]) ->
		return [] unless deps.length
		deps = prefixTaskDeps deps
		deps

	# public
	# ======
	api =
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

		startTask: (taskPath, taskOpts={}) ->
			task = require "#{config.req.tasks}#{taskPath}"
			taskOpts.taskCB = taskOpts.taskCB or ->
			return task config, gulp, taskOpts if isType.function task
			task[taskOpts.run] config, gulp, taskOpts # task is an object

		addTask: (taskName, _path, opts={}) -> # very important method
			deps     = getTaskDeps opts.deps
			taskName = prefixTask taskName

			if !deps.length
				gulp.task taskName, (cb) ->
					addedTaskCB _path, cb, opts
			else
				gulp.task taskName, gulp.series deps, (cb) ->
					addedTaskCB _path, cb, opts
