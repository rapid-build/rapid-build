/* Singleton
 * @class CoffeeSrc
 * @static
 *******************/
import Task from './../Task';
import gulp    = require('gulp');
import coffee  = require('gulp-coffee')
import plumber = require('gulp-plumber')
import Promise = require('bluebird');

class CoffeeSrc extends Task {
	private static instance: CoffeeSrc;
	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CoffeeSrc()
	}

	get opts() {
		return { bare: true }
	}

	run(src: string[] | string = [`${this.paths.src}/**/*.coffee`]) {
		return new Promise((resolve, reject) => {
			gulp.src(src)
				.pipe(plumber())
				.pipe(coffee(this.opts))
				.pipe(gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('compiled coffee to dist'.info)
		})
	}

}

export default CoffeeSrc.getInstance()