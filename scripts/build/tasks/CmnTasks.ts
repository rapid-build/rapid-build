/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Env       from './../helpers/Env';
import CleanDist from './tasks/CleanDist';
import CopySrc   from './tasks/CopySrc';
import TsSrc     from './tasks/TsSrc';
import ICmnTasks from "./../interfaces/ICmnTasks";

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
		 	var results: ICmnTasks = {
		 		clean: await(CleanDist.run()),
		 		copy: await({
					src: CopySrc.run(),
					ts: TsSrc.run()
				})
		 	};
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


