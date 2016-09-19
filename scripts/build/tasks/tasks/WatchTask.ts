/* Singleton
 * @class WatchTask
 * @static
 *******************/
import path    = require('path')
import watch   = require('node-watch')
import Promise = require('bluebird');
import Task        from './../Task';
import ModuleCache from './../../helpers/ModuleCache';

class WatchTask extends Task {
	private static instance: WatchTask;
	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchTask()
	}

	run() {
		var runBuildPath = path.join(this.paths.build, 'runBuild.js')
		var promise = new Promise((resolve, reject) => {
			watch(this.paths.build, file => {
				var cleaned = ModuleCache.delete(runBuildPath)
				if (!cleaned)
					return console.log('failed to clean module cache'.error)
				require(runBuildPath)(true)
			});
			resolve()
		})
		return promise.then((result) => {
			return console.log('WATCHING BUILD...'.attn)
		});
	}
}

export default WatchTask.getInstance()