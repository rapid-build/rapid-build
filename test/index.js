/* Register Coffee
 * Run Tests
 ******************/
require('coffee-script/register');
var path     = require('path');
var initPath = path.join(__dirname, 'init', 'index');
var pkgRoot  = path.resolve(__dirname, '..');
require(initPath)(pkgRoot);