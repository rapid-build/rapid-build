/* @class Singleton
 *******************/
import gulp    = require('gulp')
import ts      = require('gulp-typescript')
import Promise = require('bluebird')
import Vinyl   = require('vinyl')
import Task from './../Task';

class Singleton extends Task {
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
	run(src: string[] | string = this.srcGlob) {
		var promise = new Promise((resolve, reject) => {
			gulp.src(src, this.gOpts)
				.pipe(ts(this.opts))
				.pipe(gulp.dest(this.PATHS.dist))
				.on('end', () => resolve())
		})
		promise.then(() => {
			return console.log('compiled typescript to dist'.minor)
		})
		return promise;
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on(this.EVENTS.change.ts, (file: Vinyl) => {
			this.run(file.path);
		});

		this.eventEmitter.on(this.EVENTS.add.ts, (file: Vinyl) => {
			this.run(file.path);
		});

		this.eventEmitter.on(this.EVENTS.unlink.ts, (file: Vinyl) => {
			var _path = new this.utils.Path(file.path).srcToDist().swapExt('js').path;
			this.tasks.CleanDist.run(_path)
		});
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return {}
	}
	private get gOpts(): {} {
		return { base: this.PATHS.src }
	}
	private get srcGlob(): string[] {
		return [`${this.PATHS.src}/**/*.ts`]
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


