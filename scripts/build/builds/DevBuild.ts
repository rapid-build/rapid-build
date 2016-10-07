/* Singleton
 * @class DevBuild
 * @static
 ******************/
import { async, await } from 'asyncawait'
import Tasks from './../tasks/Tasks';

class DevBuild {
	readonly watch: boolean = true;
	private static instance: DevBuild;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new DevBuild()
	}

	/* Public Methods
	 *****************/
	run() {
		return async(() => {
			var results = {
				clean: await(Tasks.CleanDist.run()),
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

/* Export Singleton
 *******************/
export default DevBuild.getInstance()


