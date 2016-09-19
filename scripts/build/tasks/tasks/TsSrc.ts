/* Singleton
 * @class TsSrc
 * @static
 *******************/
import Task from './../Task';
import gulp    = require('gulp');
import ts      = require('gulp-typescript')
import Promise = require('bluebird');

class TsSrc extends Task {
	private static instance: TsSrc;
	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new TsSrc()
	}

	get opts() {
		return {}
	}

	run(src: string[] | string = [`${this.paths.src}/**/*.ts`]) {
		return new Promise((resolve, reject) => {
			gulp.src(src)
				.pipe(ts(this.opts))
				.pipe(gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('compiled typescript to dist'.info)
		})
	}

}

export default TsSrc.getInstance()