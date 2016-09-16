/* Singleton
 * @class WatchTask
 * @static
 *******************/
import Task       from './Task';
import * as watch from 'watch';

class WatchTask extends Task {
	private static instance: WatchTask;
	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchTask()
	}

	run() {
		watch.createMonitor(this.paths.build, (monitor) => {
			monitor.on('changed', (f, curr, prev) => {
				console.log(`changed: ${f}`.minor)
			})
		})

		console.log('watching build'.info)
	}
}

export default WatchTask.getInstance()