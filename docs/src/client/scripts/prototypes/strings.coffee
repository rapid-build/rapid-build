# STRING PROTOTYPES
# =================
String::trimLeft = ->
	@replace /^\s+/, ''

String::trimRight = ->
	@replace /\s+$/, ''

String::toTitleCase = ->
	@replace /\w\S*/g, (txt) ->
		txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()