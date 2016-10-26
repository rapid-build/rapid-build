/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base      from './../common/Base'
import cleanDist from './common/clean/clean-dist';
import copyJS    from './client/copy/copy-js';
import copyCSS   from './client/copy/copy-css';
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


