/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base      from './../common/Base'
import cleanDist from './clean/clean-dist';
import copyJS    from './copy/copy-js';
import copyCSS   from './copy/copy-css';
import ITask from './../interfaces/Itask'

class Singleton extends Base implements ITask {
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
				cleanDist: await(cleanDist.run()),
				copy: await({
					css: copyCSS.run(),
					js:  copyJS.run()
				})
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


