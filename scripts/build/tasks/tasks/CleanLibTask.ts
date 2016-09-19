/* Singleton
 * @class CleanLibTask
 * @static
 **********************/
import Task from './../Task';

class CleanLibTask extends Task {
	private static instance: CleanLibTask;
	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CleanLibTask()
	}

	run() {
		return this.fse.removeAsync(this.paths.dist)
		.then(() => {
			return console.log('dist cleaned'.info)
		})
	}

}

export default CleanLibTask.getInstance()