/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import CleanDist  from './tasks/CleanDist';
import CoffeeSrc  from './tasks/CoffeeSrc';
import CopySrc    from './tasks/CopySrc';
import TsSrc      from './tasks/TsSrc';

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
				clean: await(CleanDist.run()),
				copy: await({
					src: CopySrc.run(),
					coffee: CoffeeSrc.run(),
					ts: TsSrc.run()
				})
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


