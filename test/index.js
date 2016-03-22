/* TEST API (can combine args too)
 * npm test
 * npm test watch
 * npm test prod:server
 * npm test options:*
 * npm test options:exclude
 * npm test options:build:exclude
 * npm test verbose
 * npm test verbose:*
 * npm test verbose:tasks
 * npm test verbose:jasmine
 **********************************/
require('coffee-script/register');
var path     = require('path');
var initPath = path.join(__dirname, 'init', 'index');
var pkgRoot  = path.resolve(__dirname, '..');
require(initPath)(pkgRoot);