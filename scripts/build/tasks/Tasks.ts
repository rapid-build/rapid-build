/* Singleton
 * @class Tasks
 * @static
 ***************/
import CleanDist from './tasks/CleanDist';
import CoffeeSrc from './tasks/CoffeeSrc';
import CopySrc   from './tasks/CopySrc';
import TsSrc     from './tasks/TsSrc';
import WatchSrc  from './tasks/WatchSrc';

class Tasks {
	CleanDist = CleanDist;
	CoffeeSrc = CoffeeSrc;
	CopySrc   = CopySrc;
	TsSrc     = TsSrc;
	WatchSrc  = WatchSrc;
	private static instance: Tasks;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Tasks()
	}

}

/* Export Singleton
 *******************/
export default Tasks.getInstance()


