/* @function runBuild
 * @fromWatch promise
 *********************/
module.exports = (fromWatch) => {
	var Build = require('./Build').default

	return Build.run(fromWatch)
	// .then((result) => {
	// 	console.log('RUN BUILD'.attn);
	// })
}