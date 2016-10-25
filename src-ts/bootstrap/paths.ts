/* @class Singleton
 *******************/
import PATHS from '../constants/PATHS'

class Singleton {
	private static instance: Singleton;

	/* Constructor
	 **************/
	private constructor() {
		PATHS // init PATHS
		// console.log('paths initialized'.minor)
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	init(): this { // called once in bootstrap.ts
	 	return this
	}

	get() {
	 	return PATHS
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()