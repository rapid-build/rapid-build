/* npm preuninstall - currently not used
 ****************************************/
var buildStarter = require('./build-starter');

buildStarter
	.remove('build')
	.remove('options')
	.remove('gitignore')
	.remove('npmignore');
