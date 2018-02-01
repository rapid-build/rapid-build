# ==========
# TASK STORE
# ==========
# TASKS (hashmap)
# taskName:      (ex: build-spa:dev)
#	name: ''     (same as root key)
#	prefixed: '' (task name prefixed, ex: rb-build-spa:dev)
#	path: ''     (absolute to tasks folder, ex: /build/build-spa)
#	opts: {}     (various options)
# ===============================================================
Tasks = {}

# Private
# =======
Help =
	isObject: (val) -> # :boolean
		return false if typeof val isnt 'object'
		return false if val is null
		return false if Array.isArray val
		true

	isObjectWithProps: (obj) -> # :boolean
		return false unless @isObject obj
		!!Object.getOwnPropertyNames(obj).length

ts =
	_throw: (eMsg) -> # :void (throws)
		e = new Error eMsg
		console.error "ERROR: #{e.message}".error; throw e

	_warn: (msg, opts={}) -> # :void
		return if opts.silent
		console.warn "#{msg}".warn

	exists: (taskName, opts={}) -> # :boolean
		return true if Tasks[taskName] isnt undefined
		@_warn "BUILD TASK DOES NOT EXIST: #{taskName}", opts
		false

	optExists: (task, taskProp, opts={}) -> # :boolean
		return true if task.opts[taskProp] isnt undefined
		@_warn "BUILD TASK OPTION DOES NOT EXIST: #{task.name}.opts.#{taskProp}", opts
		false

	validate:
		dupCheck: (taskName) -> # :void
			return unless Tasks[taskName]
			ts._throw "DUPLICATE BUILD TASK: #{taskName}"

		exists: (taskName) -> # :void
			return if Tasks[taskName]
			ts._throw "BUILD TASK DOES NOT EXIST: #{taskName}"

		required: (taskName) -> # :void
			return taskName if taskName
			ts._throw "BUILD TASK NAME REQUIRED"

# Public
# ======
module.exports =
	getTasks: -> # :Tasks{}
		Tasks

	getTasksProp: (taskProp) -> # :[]
		vals = []
		for key, task of Tasks
			prop = task[taskProp]
			continue unless prop
			vals.push prop
		vals

	getTask: (taskName) -> # :Task{} | undefined
		return unless ts.exists taskName
		Tasks[taskName]

	addTask: (taskName, rbTaskName, taskPath, taskOpts={}) -> # :Task{}
		ts.validate.required taskName
		ts.validate.dupCheck taskName
		Tasks[taskName] =
			name: taskName
			prefixed: rbTaskName
			path: taskPath
			opts: taskOpts

	deleteTask: (taskName) -> # :void (mutator)
		return unless ts.exists taskName
		delete Tasks[taskName]

	addTaskOpt: (taskName, taskProp, taskVal) -> # :void (mutator)
		task = @getTask taskName
		task.opts[taskProp] = taskVal if task

	deleteTaskOpt: (taskName, taskProp, opts={}) -> # :void (mutator)
		task = @getTask taskName
		return unless task
		return unless ts.optExists task, taskProp, opts
		delete task.opts[taskProp]

	deleteTaskOpts: (taskName, taskOpts, opts={}) -> # :void (mutator)
		return unless Help.isObjectWithProps taskOpts
		for prop of taskOpts
			@deleteTaskOpt taskName, prop, opts

	mergeTaskOpts: (taskName, taskOpts={}) -> # :void (mutator)
		task = @getTask taskName
		Object.assign task.opts, taskOpts if task

