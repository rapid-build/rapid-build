/* Singleton
 * @class Tasks
 * @static
 **********************/
import CleanLibTask from './tasks/CleanLibTask';
import WatchTask    from './tasks/WatchTask';

class Tasks {
	private static instance: Tasks;
	CleanLibTask = CleanLibTask;
	WatchTask    = WatchTask;

	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Tasks()
	}

}

export default Tasks.getInstance()