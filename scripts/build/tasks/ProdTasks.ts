/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import MinifyScripts from './tasks/MinifyScripts';

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
	run() {
		return async(() => {
			var results = {
				minifyScripts: await(MinifyScripts.run())
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


