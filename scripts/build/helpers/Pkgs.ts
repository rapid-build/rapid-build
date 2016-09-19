/* Common/Shared Packages
 * Singleton
 * @class Pkgs
 * @static
 *************************/
import gulp    = require('gulp')
import Promise = require('bluebird')
import * as fse from 'fs-extra-promise'

class Pkgs {
	private static instance: Pkgs;
	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Pkgs()
	}

	readonly pkgs = {
		fse,
		gulp,
		Promise
	}
}

export default Pkgs.getInstance().pkgs