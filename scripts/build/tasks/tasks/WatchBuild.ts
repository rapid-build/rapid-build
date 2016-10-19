/* @class Singleton
 *******************/
import path    = require('path')
import watch   = require('gulp-watch')
import Promise = require('bluebird')
import Vinyl   = require('vinyl')
import Task         from './../Task';
import ModuleCache  from './../../helpers/ModuleCache';
import IWatchStream from "./../../interfaces/IWatchStream";

class Singleton extends Task {
	private watcher: IWatchStream;
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run() {
		var promise = new Promise((resolve, reject) => {
			this.watcher = watch(this.srcGlob, (file: Vinyl) => {
				this.emitBuildRestart(file)
				this.clearBuildCache()
				this.restartBuild()
			});
			this.watcher.on('ready', () => { resolve() })
		})
		promise.then((result) => {
			console.log('watching build...'.attn)
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
		this.Env.isWatchingBuild = true;
		return require(this.runBuildPath)();
	}

	/* Getters and Setters
	 **********************/
	private get buildEmitterPath(): string {
		return path.join(this.PATHS.build, 'events', 'BuildEmitter')
	}
	private get runBuildPath(): string { // .js ext required
		return path.join(this.PATHS.build, 'runBuild.js')
	}
	private get srcGlob(): string[] {
		return [
			this.PATHS.build,
			`!${this.PATHS.build}/**/.DS_Store`,
			`!${this.PATHS.build}/**/npm-debug.log`,
			`!${this.PATHS.build}/typings/**`,
			`!${this.PATHS.build}/node_modules/**`
		]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


