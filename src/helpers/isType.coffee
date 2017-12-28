module.exports =
	# type
	# ====
	get: (v) -> # :string | void
		for own key of @
			continue if key is 'get'
			continue if key is 'stringArray' # TODO
			return key if @[key] v
		console.log new Error("type not in lib: #{v}").message.warn
		undefined

	# types (all return :boolean)
	# =====
	array: (v) ->
		Array.isArray v

	boolean: (v) ->
		typeof v is 'boolean'

	error: (v) ->
		v instanceof Error

	function: (v) ->
		typeof v is 'function'

	int: (v) ->
		return false unless @number v
		v % 1 is 0

	null: (v) ->
		v is null

	number: (v) ->
		return false if @null v
		return false if @array v
		return false if @string v
		return false if @boolean v
		not isNaN v

	object: (v) ->
		return false if typeof v isnt 'object'
		return false if v is null
		return false if @array v
		true

	string: (v) ->
		typeof v is 'string'

	stringArray: (v) -> # v should be an array of strings
		return false unless @array v
		for val in v
			return false unless @string val
		true

	undefined: (v) ->
		v is undefined
