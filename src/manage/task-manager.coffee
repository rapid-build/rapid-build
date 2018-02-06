# Task Manager
# ============
module.exports = (config, gulp) ->
	log       = require "#{config.req.helpers}/log"
	isType    = require "#{config.req.helpers}/isType"
	taskStore = require "#{config.req.manage}/task-store"

	# private
	# =======
	prefixTask = (taskName) -> # :string
		config.rb.prefix.task + taskName

	prefixTaskDeps = (deps) -> # :string[]
		deps = (prefixTask dep for dep in deps)

	getTaskDeps = (deps=[]) -> # :string[]
		return [] unless deps.length
		deps = prefixTaskDeps deps
		deps

	# public
	# ======
	api =
		runWatchTask: (taskName, watchOpts) -> # :promise
			@runTask(taskName, watchOpts).then ->
				return if watchOpts.keep # see watch inline-js-html-imports:dev
				taskStore.deleteTaskOpts taskName, watchOpts, silent: true

		runTask: (taskName, opts) -> # :promise
			task = taskStore.getTask taskName
			taskStore.mergeTaskOpts task.name, opts if opts
			runTask = require "#{config.req.tasks}#{task.path}"

			if task.opts.run
				promise = runTask[task.opts.run] config, gulp, task
			else
				promise = runTask config, gulp, task

			promise.then (res) ->
				return unless isType.object res
				return unless res.log     # :boolean | string (log type ex: 'minor')
				return unless res.message # string[] | string
				log.task res.message, res.log
			.catch (e) ->
				log.taskError e, task

			promise

		addTask: (taskName, _path, opts={}) -> # :void (very important method)
			deps       = getTaskDeps opts.deps
			rbTaskName = prefixTask taskName # gulp task name
			task       = taskStore.addTask taskName, rbTaskName, _path, opts

			if !deps.length
				gulp.task rbTaskName, ->
					api.runTask task.name
			else
				gulp.task rbTaskName, gulp.series deps, ->
					api.runTask task.name
