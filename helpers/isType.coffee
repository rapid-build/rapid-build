module.exports =
	array: (v) ->
		Array.isArray v

	int: (v) ->
		return false if not @number v
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