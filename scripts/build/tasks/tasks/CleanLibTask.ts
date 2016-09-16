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
		var promise = this.fse.removeAsync(this.paths.dist);
		promise.then(() => {
			console.log('dist cleaned'.info)
		})
		return promise;
	}

}

export default CleanLibTask.getInstance()