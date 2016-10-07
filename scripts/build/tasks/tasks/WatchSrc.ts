/* Singleton
 * @class WatchSrc
 * @static
 ******************/
import path  = require('path')
import watch = require('gulp-watch')
import Vinyl = require('vinyl')
import Task         from './../Task';
import IWatchStream from "./../../interfaces/IWatchStream";

class WatchSrc extends Task {
	private watcher: IWatchStream;
	private static instance: WatchSrc;

	/* Constructor
	 **************/
	private constructor() {
		super()
		this.addListeners()
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchSrc()
	}

	/* Public Methods
	 *****************/
	run() {
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.watcher = watch(this.paths.src, this.opts, (file: Vinyl) => {
				this.eventEmitter.emitWatch(file);
			})
			this.watcher.on('ready', () => {
				resolve()
			})
		})
		promise.then((result) => {
			console.log('watching src...'.info)
		});
		return promise;
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on('build restart', () => {
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
export default WatchSrc.getInstance()


