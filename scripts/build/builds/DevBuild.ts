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

	private runTasks = async((watch) => {
		await(Tasks.CleanLibTask.run());
		if (watch) Tasks.WatchTask.run()
	})

	run(watch?: boolean) {
		return this.runTasks(watch);
	}

}

export default DevBuild.getInstance()