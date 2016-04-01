/* INIT THE BUILD
 *****************/
module.exports = function(gulp, options) {
	var path      = require('path'),
		parentDir = path.basename(__dirname), // src or lib
		isLib     = parentDir == 'lib';

	if (!isLib) require('coffee-script/register');
	return require('./gulpfile')(gulp, options)
}