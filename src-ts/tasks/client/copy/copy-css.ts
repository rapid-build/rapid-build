/* @class Singleton
 *******************/
import gulp = require('gulp')
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
				.pipe(gulp.dest(this.dest))
				.on('end', () => resolve(true))
		})
		promise.then(() => {
			return console.log('copied css to /dist/client'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get gOpts(): {} {
		return { base: this.paths.app.src.client.styles.path }
	}
	private get dest(): string {
		return this.paths.app.dist.client.styles.path;
	}
	private get srcGlob(): string[] {
		return [
			`${this.paths.app.src.client.styles.path}/**/*.css`,
		]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


