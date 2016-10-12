/* Common/Shared Packages
 * @class Singleton
 *************************/
import gulp    = require('gulp')
import Promise = require('bluebird')
import * as fse from 'fs-extra-promise'

class Singleton {
	readonly pkgs = {
		fse,
		gulp,
		Promise
	}
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance().pkgs


