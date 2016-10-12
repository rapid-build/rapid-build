/* @function runBuild
 * @fromWatch promise
 * required from index.js and WatchBuild.ts
 *******************************************/
module.exports = (fromWatch) => {
	var Build = require('./Build').default

	return Build.run(fromWatch)
	// .then((result) => {
	// 	console.log('RUN BUILD'.attn);
	// })
}