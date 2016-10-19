/* @function runBuild
 * @fromWatch promise
 * required from index.js and WatchBuild.ts
 *******************************************/
module.exports = () => {
	require('./bootstrap/add-colors');
	var Build = require('./Build').default

	return Build.run()
}