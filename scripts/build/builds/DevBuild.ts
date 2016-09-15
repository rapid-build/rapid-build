/* Singleton
 * @class DevBuild
 * @static
 ******************/
import { async, await } from 'asyncawait'
import Tasks from './../tasks/Tasks';

class DevBuild {
	private static instance: DevBuild;

	private constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new DevBuild()
	}

	private runTasks = async(() => {
		await(Tasks.CleanLibTask.run());
	})

	run() {
		return this.runTasks();
	}

}

export default DevBuild.getInstance()