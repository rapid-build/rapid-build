/* @class Singleton
 *******************/
import gulp    = require('gulp')
import babel   = require('gulp-babel')
import es2015  = require('babel-preset-es2015')
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
				.pipe(babel(this.opts))
				.pipe(gulp.dest(this.dest))
				.on('end', () => resolve(true))
		})
		promise.then(() => {
			return console.log('compiled es6 to /dist/client'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get opts() {
		return { presets: [ es2015 ] } // performance hit (es2015)
	}
	private get gOpts(): {} {
		return { base: this.paths.app.src.client.scripts.path }
	}
	private get dest() {
		return this.paths.app.dist.client.scripts.path
	}
	private get srcGlob() {
		return [
			`${this.paths.app.src.client.scripts.path}/**/*.es6`,
		]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()

