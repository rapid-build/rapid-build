require('colors')

var getSeparator = function(msg) {
	var i   = 0
	var sep = ''
	var len = msg.length
	for (; i < len; i++) {
		sep += '-'
	}
	return sep
}

var logMsg = function(msg) {
	var sep = getSeparator(msg)
	console.log(sep)
	console.log(msg.toUpperCase().yellow)
	console.log(sep)
	return
}

module.exports = logMsg