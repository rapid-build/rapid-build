/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base      from './../common/Base'
import ITask     from './../interfaces/ITask'
import cleanDist from './common/clean/clean-dist';
import copyJS    from './client/copy/copy-js';
import copyCSS   from './client/copy/copy-css';
import coffee    from './client/compile/coffee';

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
				client: await({
					compile: {
						coffee: coffee.run()
					},
					copy: {
						css: copyCSS.run(),
						js:  copyJS.run()
					}
				})
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


