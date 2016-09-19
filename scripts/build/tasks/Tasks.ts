/* Singleton
 * @class Tasks
 * @static
 ***************/
import CleanLibTask from './tasks/CleanLibTask';
import CoffeeSrc    from './tasks/CoffeeSrc';
import CopySrc      from './tasks/CopySrc';
import TsSrc        from './tasks/TsSrc';

class Tasks {
	CleanLibTask = CleanLibTask;
	CopySrc      = CopySrc;
	CoffeeSrc    = CoffeeSrc;
	TsSrc        = TsSrc;
	private static instance: Tasks;
	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Tasks()
	}

}

export default Tasks.getInstance()