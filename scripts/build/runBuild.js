/* @function runBuild
 * @fromWatch promise
 * required from index.js and WatchBuild.ts
 *******************************************/
module.exports = () => {
	require('./bootstrap/add-colors');
	require('./bootstrap/polyfills');

	var Build = require('./Build').default
	return Build.run()
}