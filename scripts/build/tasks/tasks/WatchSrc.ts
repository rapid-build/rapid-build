/* Singleton
 * @class WatchSrc
 * @static
 ******************/
import path  = require('path')
import watch = require('gulp-watch')
import Vinyl = require('vinyl')
import Task         from './../Task';
import BuildEmitter from './../../events/BuildEmitter';
import SrcEmitter   from './../../events/SrcEmitter';
import IWatchStream from "./../../interfaces/IWatchStream";

class WatchSrc extends Task {
	private watcher: IWatchStream;
	private static instance: WatchSrc;
	protected constructor() {
		super()
		this.addListeners()
	}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchSrc()
	}

	private addListeners() {
		BuildEmitter.event.on('restart build', () => {
			this.watcher.close();
		});
	}

	private get opts() {
		return { read: false }
	}

	/* API
	 ******/
	run() {
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.watcher = watch(this.paths.src, this.opts, (file: Vinyl) => {
				SrcEmitter.run(file)
			})
			this.watcher.on('ready', () => {
				resolve()
			})
		})
		return promise.then((result) => {
			return console.log('watching src...'.attn)
		});
	}
}

export default WatchSrc.getInstance()