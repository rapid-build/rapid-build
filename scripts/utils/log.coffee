# LOG UTILITY
# deps: ../bootstrap/colors
# =========================
module.exports =
	_isNumber: (msg) ->
		return false if typeof msg is 'string'
		!isNaN msg

	_validType: (msg) ->
		type = typeof msg
		type is 'string' or type is 'number'

	msg: (msg, type='info', uppercase=false) ->
		return console.log msg if not @_validType msg
		msg = msg.toString 10 if @_isNumber msg
		msg = msg.toUpperCase() if uppercase
		console.log msg[type]

	msgWithSeps: (msg, type='info', top=true, bot=true, uppercase=false, length=0) ->
		return console.log msg if not @_validType msg
		msg  = msg.toString 10 if @_isNumber msg
		len  = if length > 0 then length else msg.length
		sep  = Array(len+1).join '-'
		tSep = if top then "#{sep}\n" else ''
		bSep = if bot then "\n#{sep}" else ''
		msg  = msg.toUpperCase() if uppercase
		msg  = "#{tSep}#{msg}#{bSep}"
		console.log msg[type]

	separator: (length=0, type='info') -> # separator only
		return unless length > 0
		sep = Array(length+1).join '-'
		console.log sep[type]