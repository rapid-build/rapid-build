/* @class Singleton
 *******************/
import path  = require('path')
import watch = require('gulp-watch')
import Vinyl = require('vinyl')
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
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.watcher = watch(this.PATHS.src, this.opts, (file: Vinyl) => {
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

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


