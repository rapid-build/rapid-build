/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base      from './../classes/Base'
import cleanDist from './clean/cleanDist';
import copyJS    from './copy/copyJS';
import copyCSS   from './copy/copyCSS';

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


