/* @class Singleton
 *******************/
import path    = require('path')
import watch   = require('gulp-watch')
import Promise = require('bluebird')
import Vinyl   = require('vinyl')
import Task         from './../Task';
import IWatchStream from "./../../interfaces/IWatchStream";

class Singleton extends Task {
	private watcher: IWatchStream;
	private static instance: Singleton;

	/* Constructor
	 **************/
	private constructor() {
		super()
		if (this.Env.isDev) this.addListeners()
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run() {
		var promise = new Promise((resolve, reject) => {
			this.watcher = watch(this.srcGlob, this.opts, (file: Vinyl) => {
				this.eventEmitter.emitWatch(file);
			})
			this.watcher.on('ready', () => {
				resolve()
			})
		})
		promise.then((result) => {
			console.log('watching src...'.minor)
		});
		return promise;
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on(this.EVENTS.restart.build, (file: Vinyl) => {
			this.watcher.close();
		});
	}

	/* Getters and Setters
	 **********************/
	private get opts() {
		return { read: false }
	}
	private get srcGlob(): string[] {
		return [
			this.PATHS.src,
			`!${this.PATHS.src}/**/.DS_Store`,
			`!${this.PATHS.src}/**/npm-debug.log`,
			`!${this.PATHS.src}/**/{tsconfig,typings}.json`,
			`!${this.PATHS.src}/typings/**`,
			`!${this.PATHS.src}/node_modules/**`
		]
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


