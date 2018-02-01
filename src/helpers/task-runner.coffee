module.exports = (config) ->
	q   = require 'q'
	log = require "#{config.req.helpers}/log"

	# private
	# =======
	IS = # 'is' is a keyword in coffee
		extraTask: (Task) ->
			Task.path.indexOf('/extra') is 0

	get =
		_tasksArgs: (locs, type, lang) -> # :Object[]
			args = []
			for loc in locs
				for appOrRb in ['rb','app']
					src = config.glob.src[appOrRb][loc][type][lang]
					continue unless src and src.length # gulp 4 requires a src value
					dest = config.dist[appOrRb][loc][type].dir
					opts = { appOrRb, loc }
					args.push { src, dest, opts }
			args

		_extraTasksArgs: (locs, type, lang) -> # :Object[] (for build option extra tasks)
			args = []
			for loc in locs
				for appOrRb in ['rb','app']
					src = config.extra[type][appOrRb][loc] # type ex: copy | compile
					src = src[lang] if lang # lang ex: coffee | less (type copy has no lang)
					continue unless src and src.length
					dest = config.dist[appOrRb][loc].dir
					base = config.src[appOrRb][loc].dir
					opts = { appOrRb, loc, base }
					args.push { src, dest, opts }
			args

		_tasks: (runTask, tasksArgs) -> # :Function[] :Promise
			tasks = []
			for arg, i in tasksArgs
				do (arg) ->
					tasks[i] = -> runTask arg.src, arg.dest, arg.opts
			tasks

		tasks: (runTask, type, lang, locs, Task) -> # :Function[] :Promise
			getTasksArgs = '_tasksArgs'
			getTasksArgs = '_extraTasksArgs' if IS.extraTask Task
			tasksArgs    = @[getTasksArgs] locs, type, lang
			@_tasks runTask, tasksArgs

		taskResult: (Task) -> # :{}
			result = message: "completed all tasks"
			return result unless Task
			result.message += ": #{Task.name}"
			result

	# public
	# ======
	api =
		async: (runTask, type, lang, locs, Task) -> # :Promise
			tasks = get.tasks runTask, type, lang, locs, Task
			tasks = tasks.map (task) -> task()
			q.all(tasks).then ->
				get.taskResult Task

		sync: (runTask, type, lang, locs, Task) -> # :Promise
			tasks = get.tasks runTask, type, lang, locs, Task
			tasks.reduce(q.when, q()).then ->
				get.taskResult Task
