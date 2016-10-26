/* @class Singleton
 *******************/
import gulp    = require('gulp')
import coffee  = require('gulp-coffee')
import plumber = require('gulp-plumber')
import Base  from './../../../common/Base'
import ITask from './../../../interfaces/ITask'

class Singleton extends Base implements ITask {
	private static instance: Singleton;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		var promise = new Promise((resolve, reject) => {
			gulp.src(src, this.gOpts)
				.pipe(plumber())
				.pipe(coffee(this.opts))
				.pipe(gulp.dest(this.dest))
				.on('end', () => resolve(true))
		})
		promise.then(() => {
			return console.log('compiled coffee to /dist/client'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return { bare: true }
	}
	private get gOpts(): {} {
		return { base: this.paths.app.src.client.scripts.path }
	}
	private get dest(): string {
		return this.paths.app.dist.client.scripts.path
	}
	private get srcGlob(): string[] {
		return [
			`${this.paths.app.src.client.scripts.path}/**/*.coffee`,
		]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()

