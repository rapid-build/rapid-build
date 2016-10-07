/* Common/Shared Packages
 * Singleton
 * @class Pkgs
 * @static
 *************************/
import gulp    = require('gulp')
import Promise = require('bluebird')
import * as fse from 'fs-extra-promise'

class Pkgs {
	readonly pkgs = {
		fse,
		gulp,
		Promise
	}
	private static instance: Pkgs;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Pkgs()
	}

}

/* Export Singleton
 *******************/
export default Pkgs.getInstance().pkgs


