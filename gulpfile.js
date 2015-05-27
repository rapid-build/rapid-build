// init rapid-build
module.exports = function(options) {
	require('coffee-script/register')
	return require('./gulpfile.coffee')(options)
}