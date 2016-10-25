/* PACKAGE ENTRY SCRIPT
 * package.json's main field value (TODO)
 *****************************************/
import bootstrap from './bootstrap'
import build     from './build';

module.exports = () => {
	bootstrap.run()
	return build.run() // returns promise
}