/* Singleton
 * @class WatchBuild
 * @static
 ********************/
import path  = require('path')
import watch = require('gulp-watch')
import Vinyl = require('vinyl')
import Task         from './../Task';
import ModuleCache  from './../../helpers/ModuleCache';
import IWatchStream from "./../../interfaces/IWatchStream";

class WatchBuild extends Task {
	private watcher: IWatchStream;
	private static instance: WatchBuild;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchBuild()
	}

	/* Public Methods
	 *****************/
	run() {
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.watcher = watch(this.PATHS.build, (file: Vinyl) => {
				this.emitBuildRestart(file)
				this.clearBuildCache()
				this.restartBuild()
			});
			this.watcher.on('ready', () => { resolve() })
		})
		promise.then((result) => {
			console.log('watching build...'.info)
		});
		return promise;
	}

	/* Private Methods
	 ******************/
	private emitBuildRestart(file: Vinyl): boolean {
		return require(this.buildEmitterPath).default.emitWatch(file);
	}

	private clearBuildCache(): boolean {
		var cleaned = ModuleCache.delete(this.runBuildPath);
		if (!cleaned) console.log('failed to clean module cache'.error)
		return cleaned;
	}

	private restartBuild() {
		return require(this.runBuildPath)(true);
	}

	/* Getters and Setters
	 **********************/
	private get buildEmitterPath(): string {
		return path.join(this.PATHS.build, 'events', 'BuildEmitter')
	}
	private get runBuildPath(): string { // .js ext required
		return path.join(this.PATHS.build, 'runBuild.js')
	}
}

/* Export Singleton
 *******************/
export default WatchBuild.getInstance()


