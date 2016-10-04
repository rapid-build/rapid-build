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
			var results = {
				clean: await(Tasks.CleanLib.run()),
				copy: await({
					src: Tasks.CopySrc.run(),
					coffee: Tasks.CoffeeSrc.run(),
					ts: Tasks.TsSrc.run()
				}),
				watch: await(Tasks.WatchSrc.run())
			}
			return results
		})();
	}

}

export default DevBuild.getInstance()