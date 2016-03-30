module.exports =
	array: (v) ->
		Array.isArray v

	boolean: (v) ->
		typeof v is 'boolean'

	function: (v) ->
		typeof v is 'function'

	int: (v) ->
		return false unless @number v
		v % 1 is 0

	null: (v) ->
		v is null

	number: (v) ->
		return false if @string v
		not isNaN(v)

	object: (v) ->
		return false if typeof v isnt 'object'
		return false if v is null
		return false if @array v
		true

	string: (v) ->
		typeof v is 'string'

	undefined: (v) ->
		v is undefined
