/* Singleton
 * @class WatchBuild
 * @static
 ********************/
import path  = require('path')
import watch = require('node-watch')
import { async, await } from 'asyncawait'
import Task             from './../Task';
import ModuleCache      from './../../helpers/ModuleCache';

class WatchBuild extends Task {
	private static instance: WatchBuild;

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchBuild()
	}

	private emit() {
		var BuildEmitter = require('./../../events/BuildEmitter').default
		BuildEmitter.event.emit('restart build');
	}

	/* API
	 ******/
	run() {
		var runBuildPath = path.join(this.paths.build, 'runBuild.js')
		var promise = new this.pkgs.Promise((resolve, reject) => {
			watch(this.paths.build, async(filePath => {
				var cleaned = ModuleCache.delete(runBuildPath)
				if (!cleaned) return console.log('failed to clean module cache'.error)
				await(require(runBuildPath)(true));
				this.emit()
			}));
			resolve()
		})
		return promise.then((result) => {
			return console.log('WATCHING BUILD...'.attn)
		});
	}
}

export default WatchBuild.getInstance()