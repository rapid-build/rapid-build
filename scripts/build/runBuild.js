/* @function runBuild
 * @fromWatch promise
 * required from index.js and WatchBuild.ts
 *******************************************/
module.exports = () => {
	// process.env.RB_SRC_DIR = 'src-ts';

	require('./bootstrap/add-colors');
	var Build = require('./Build').default

	return Build.run()
}