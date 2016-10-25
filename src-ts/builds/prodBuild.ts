/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base     from './../classes/Base'
import cmnTasks from './../tasks/cmnTasks'

class Singleton extends Base {
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
				cmnTasks: await(cmnTasks.run())
			}
			return results;
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()