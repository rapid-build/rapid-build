module.exports = server => {
	var app = server.app

	/* Testing
	 **********/
	var buildStarter = require('./pkg/build-starter')

	// buildStarter
	// 	.create('build').create('options')
	// 	.create('gitignore').create('npmignore')

	// buildStarter
	// 	.remove('build').remove('options')
	// 	.remove('gitignore').remove('npmignore')


	/* Mimic Pkg Install
	 ********************/
	// require('./pkg/create-build-files')
	// require('./pkg/clean-build-files')
};