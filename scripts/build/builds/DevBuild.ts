/* Singleton
 * @class DevBuild
 * @static
 ******************/
import { async, await } from 'asyncawait'
import Tasks from './../tasks/Tasks';

class DevBuild {
	readonly watch: boolean = true;
	private static instance: DevBuild;

	private constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new DevBuild()
	}

	run() {
		return async(() => {
			var r1 = await(Tasks.CleanLibTask.run())
			return r1
		})();
	}

}

export default DevBuild.getInstance()