/* BOOTSTRAP
 ************/
require('./bootstrap/colors')
require('./bootstrap/polyfills')
import env   from './bootstrap/env'
import paths from './bootstrap/paths'
import log   from './utils/log'

class Singleton {
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run(): this {
		log.msgDivs(`Running Build: ${env.name}`, 'attn')
		console.log('bootstrap complete'.minor)
		return this
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()