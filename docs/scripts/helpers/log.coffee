# deps: colors
# ============
module.exports = (msg, type='attn') ->
	method   = if type is 'error' then 'error' else 'log'
	newLine  = '\n'
	hasLines = msg.indexOf(newLine) isnt -1
	length   = if hasLines then 0 else msg.length

	if hasLines
		lines = msg.split newLine
		for line in lines
			continue if line.length <= length
			length = line.length

	sep = '-'.repeat length
	console[method] sep[type]
	console[method] msg[type]
	console[method] sep[type]