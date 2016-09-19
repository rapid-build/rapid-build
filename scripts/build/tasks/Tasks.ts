/* Singleton
 * @class Tasks
 * @static
 ***************/
import CleanLib  from './tasks/CleanLib';
import CoffeeSrc from './tasks/CoffeeSrc';
import CopySrc   from './tasks/CopySrc';
import TsSrc     from './tasks/TsSrc';

class Tasks {
	CleanLib  = CleanLib;
	CoffeeSrc = CoffeeSrc;
	CopySrc   = CopySrc;
	TsSrc     = TsSrc;
	private static instance: Tasks;
	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Tasks()
	}

}

export default Tasks.getInstance()