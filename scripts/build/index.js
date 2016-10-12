/* BUILD ENTRY
 * executed via: npm run build
 ******************************/
var path     = require('path'),
	tsconfig = path.join(__dirname, 'tsconfig.json');

require('ts-node').register({
	project: tsconfig
})
require('./runBuild')()