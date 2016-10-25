/* BOOTSTRAP
 ************/
require('./bootstrap/colors')
require('./bootstrap/polyfills')
import env from './bootstrap/env'
import PATHS from './constants/PATHS'

class Singleton {
	private static instance: Singleton;

	/* Constructor
	 **************/
	private constructor() {
		env.set()
		// console.log(PATHS)
		// console.log(PATHS.rb)
		// console.log(PATHS.app)
		// console.log(env.name)
		// console.log(env.isTest)
		// env.set('prod')
		// console.log(env.name)
		// console.log(env.isTest)

	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run() {
		console.log('bootstrap complete'.attn)
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()