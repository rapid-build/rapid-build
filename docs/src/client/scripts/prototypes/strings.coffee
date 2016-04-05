# STRING PROTOTYPES
# =================
String::trimLeft = ->
	@replace /^\s+/, ''

String::trimRight = ->
	@replace /\s+$/, ''