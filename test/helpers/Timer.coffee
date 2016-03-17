class Timer
	constructor: (name, start=false) ->
		args  = Array.prototype.slice.call arguments # convert to array
		name  = if typeof args[0] is 'string' then args[0] else args[1]
		@name = if !!name then "#{name} #{@name}" else "#{@name}"
		start = args.indexOf(true) isnt -1
		@start() if start

	# props
	# =====
	name:  'timer'
	time:  0
	timer: undefined

	# methods
	# =======
	start: ->
		@timer = setInterval (me) ->
			me.set @_idleStart
		, 1, @
		@

	clear: (log=false) ->
		@log() if log is true
		@set 0
		clearInterval @timer
		@

	log: ->
		msg = "#{@get()} -> #{@name}"
		console.log msg.info.bold
		@

	# getters and setters
	# ===================
	get: -> @time
	set: (@time) -> @

# export it!
# ==========
module.exports = Timer