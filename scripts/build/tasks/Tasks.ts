/* Singleton
 * @class Tasks
 * @static
 **********************/
import CleanLibTask from './CleanLibTask';

class Tasks {
	CleanLibTask = CleanLibTask;
	private static instance: Tasks;

	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Tasks()
	}

}

export default Tasks.getInstance()