module.exports = ->
	q = require 'q'

	run:
		all: (config, tasksCb, type, lang, locs, async) ->
			tasks = []
			defer = q.defer()

			locs.forEach (v1) ->
				['rb','app'].forEach (v2) ->
					tasks.push
						src:  config.glob.src[v2][v1][type][lang]
						dest: config.dist[v2][v1][type].dir
			if async
				tasks.forEach (v, i) ->
					tasks[i] = tasksCb v.src, v.dest

			else # sync, wrap task with fn for ordered promises
				tasks.forEach (v, i) ->
					tasks[i] = -> tasksCb v.src, v.dest

			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise
