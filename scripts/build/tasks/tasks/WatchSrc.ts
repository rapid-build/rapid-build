/* Singleton
 * @class WatchSrc
 * @static
 ******************/
import path  = require('path')
import watch = require('gulp-watch')
import Task         from './../Task';
import BuildEmitter from './../../events/BuildEmitter';

class WatchSrc extends Task {
	private watcher: any;
	private static instance: WatchSrc;
	protected constructor() {
		super()
		this.addListeners()
	}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new WatchSrc()
	}

	private get opts() {
		return { read: false }
	}

	addListeners() {
		BuildEmitter.event.on('restart build', () => {
			this.watcher.close();
		});
	}

	run() {
		var runBuildPath = path.join(this.paths.build, 'runBuild.js')
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.watcher = watch(this.paths.src, this.opts, file => {
				console.log(file.relative)
			}).on('ready', () => {
				resolve()
			})
		})
		return promise.then((result) => {
			return console.log('watching src...'.attn)
		});
	}
}

export default WatchSrc.getInstance()