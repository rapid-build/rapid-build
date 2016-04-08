/* npm postinstall
 ******************/
var buildStarter = require('./build-starter');

buildStarter
	.create('build')
	.create('options')
	.create('gitignore')
	.create('npmignore');
