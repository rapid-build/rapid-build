/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import gulp    = require('gulp')
import less    = require('gulp-less')
import plumber = require('gulp-plumber')
import Base  from './../../../common/Base'
import ITask from './../../../interfaces/ITask'
import Less  from './../../../utils/Less'

class Singleton extends Base implements ITask {
	private static instance: Singleton;
	private less = new Less();

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		return async(() => {
		 	src = await(this.less.getSrc(src))
			var results = await(this.lessTask(src))
			return results
		})()
	}

	/* Private Methods
	 ******************/
	private lessTask(src: string[] | string = this.srcGlob) {
		var promise = new Promise((resolve, reject) => {
			gulp.src(src, this.gOpts)
				.pipe(plumber())
				.pipe(less(this.opts))
				.pipe(gulp.dest(this.dest))
				.on('end', () => resolve(true))
		})
		promise.then(() => {
			return console.log('compiled less to /dist/client/styles'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get opts() {
		return {}
	}
	private get gOpts() {
		return { base: this.paths.app.src.client.styles.path }
	}
	private get dest() {
		return this.paths.app.dist.client.styles.path
	}
	private get srcGlob() {
		return [
			`${this.paths.app.src.client.styles.path}/**/*.less`,
		]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()

