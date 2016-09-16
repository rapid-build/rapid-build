/* Singleton
 * @class WatchTask
 * @static
 *******************/
import path  = require('path')
import watch = require('node-watch')
import Task     from './../Task';
import DevBuild from './../../builds/DevBuild';

class WatchTask extends Task {
	private static instance: WatchTask;

	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchTask()
	}

	run() {
		// watcher.close()
		var watcher = watch(this.paths.build, file => {
			// watcher.close()
			DevBuild.run()
		});

		console.log('watching build'.info)
	}
}

export default WatchTask.getInstance()