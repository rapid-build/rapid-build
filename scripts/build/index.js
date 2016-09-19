/* BUILD ENTRY
 * Excluded from watch.
 ***********************/
var path     = require('path'),
	tsconfig = path.join(__dirname, 'tsconfig.json');

require('ts-node').register({
	project: tsconfig
})
require('./runBuild')()