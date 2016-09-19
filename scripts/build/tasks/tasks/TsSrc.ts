/* Singleton
 * @class TsSrc
 * @static
 *******************/
import ts = require('gulp-typescript')
import Task from './../Task';

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
		return new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src)
				.pipe(ts(this.opts))
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('compiled typescript to dist'.info)
		})
	}

}

export default TsSrc.getInstance()