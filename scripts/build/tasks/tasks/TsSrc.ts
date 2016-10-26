/* @class Singleton
 *******************/
import typescript = require('typescript')
import path       = require('path')
import gulp       = require('gulp')
import ts         = require('gulp-typescript')
import Vinyl      = require('vinyl')
import Task from './../Task';

class Singleton extends Task {
	private _tsProject;
	private static instance: Singleton;

	/* Constructor
	 **************/
	private constructor() {
		super()
		this.tsProject = this.opts
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
				.pipe(ts(this.tsProject))
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
		var glob: string[];
		// was `${this.PATHS.src}/{defs,typings}/**/*.ts`: TODO(fix this)
		var typings: string = this.srcGlob[0];

		this.eventEmitter.on(this.EVENTS.change.ts, (file: Vinyl) => {
			glob = [].concat(file.path, typings);
			this.run(glob);
		});

		this.eventEmitter.on(this.EVENTS.add.ts, (file: Vinyl) => {
			glob = [].concat(file.path, typings);
			this.run(glob);
		});

		this.eventEmitter.on(this.EVENTS.unlink.ts, (file: Vinyl) => {
			var _path = new this.utils.Path(file.path).srcToDist().swapExt('js').path;
			this.tasks.CleanDist.run(_path)
		});
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return { typescript }
	}
	private get gOpts(): {} {
		return { base: this.PATHS.src }
	}
	private get srcGlob(): string[] {
		return [`${this.PATHS.src}/**/*.ts`]
	}
	private get tsProject() {
		return this._tsProject
	}

	private set tsProject(opts) {
		var tsconfig = path.join(this.PATHS.src, 'tsconfig.json');
		this._tsProject = ts.createProject(tsconfig, this.opts);
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


