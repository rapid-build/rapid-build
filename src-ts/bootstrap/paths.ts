/* @class Singleton
 *******************/
import PATHS from '../constants/PATHS'

class Singleton {
	private static instance: Singleton;
	readonly paths;

	/* Constructor
	 **************/
	private constructor() {
		this.paths = PATHS;
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()