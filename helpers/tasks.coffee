module.exports = (gulp={}) ->
	q = require 'q'

	# private
	# =======
	getTasks = (config, tasksCb, type, lang, locs) ->
		tasks = []
		locs.forEach (v1) ->
			['rb','app'].forEach (v2) ->
				tasks.push
					src:  config.glob.src[v2][v1][type][lang]
					dest: config.dist[v2][v1][type].dir
		tasks.forEach (v, i) ->
			tasks[i] = -> tasksCb v.src, v.dest
		tasks

	# public
	# ======
	run:
		async: (config, tasksCb, type, lang, locs) ->
			tasks    = getTasks config, tasksCb, type, lang, locs
			defer    = q.defer()
			promises = tasks.map (task) -> task()
			q.all(promises).done -> defer.resolve()
			defer.promise

		sync: (config, tasksCb, type, lang, locs) ->
			tasks = getTasks config, tasksCb, type, lang, locs
			defer = q.defer()
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	wasCalledFrom: (task) -> # return boolean
		calledFromTask = gulp.seq.indexOf(task) isnt -1
		# console.log "was called from task #{task} = #{calledFromTask}".yellow
		calledFromTask