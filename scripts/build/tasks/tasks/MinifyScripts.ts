/* @class Singleton
 *******************/
import path   = require('path')
import uglify = require('gulp-uglify')
import Task from './../Task';

class Singleton extends Task {
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
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, this.gOpts)
				.pipe(uglify(this.opts))
				.on('error', e => {
					e.message += `\nFile: ${e.cause.filename}`
					return reject(e);
				})
				.pipe(this.pkgs.gulp.dest(this.PATHS.dist))
				.on('end', () => resolve())
		})
		promise.then(() => {
			return console.log('minified dist js files'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return { mangle: true }
	}
	private get gOpts(): {} {
		return { base: this.PATHS.dist }
	}
	private get srcGlob(): string[] {
		var srcSrc = `!${path.join(this.PATHS.dist, 'src')}/**`;
		return [
			`${this.PATHS.dist}/**/*.js`,
			srcSrc
		]
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


