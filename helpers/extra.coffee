module.exports = (config) ->
	q           = require 'q'
	promiseHelp = require "#{config.req.helpers}/promise"

	# private
	# =======
	getTasks = (tasksCb, srcBase, srcTask, locs) ->
		args  = []
		tasks = []
		for appOrRb in ['rb','app']
			for loc in locs
				src = srcBase[appOrRb][loc]
				src = src[srcTask] if srcTask
				_args = {
					src
					dest: config.dist[appOrRb][loc].dir
					base: config.src[appOrRb][loc].dir
					appOrRb, loc
				}
				continue unless _args.src
				continue unless _args.src.length
				args.push _args
		return tasks unless args.length
		for v, i in args
			do (v) ->
				tasks[i] = -> tasksCb v.src, v.dest, v.base, v.appOrRb, v.loc
		tasks

	# public
	# ======
	run:
		tasks:
			async: (tasksCb, task, subTask, locs) ->
				defer = q.defer()
				tasks = getTasks tasksCb, config.extra[task], subTask, locs
				return promiseHelp.get defer unless tasks.length
				promises = tasks.map (_task) -> _task()
				q.all(promises).done -> defer.resolve()
				defer.promise

			sync: (tasksCb, task, subTask, locs) ->
				defer = q.defer()
				tasks = getTasks tasksCb, config.extra[task], subTask, locs
				return promiseHelp.get defer unless tasks.length
				tasks.reduce(q.when, q()).done -> defer.resolve()
				defer.promise