/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import WatchSrc from './tasks/WatchSrc';

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
				watchSrc: await(WatchSrc.run())
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


