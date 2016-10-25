/* @class Singleton
 *******************/
import gulp  = require('gulp')
import Vinyl = require('vinyl')
import Base from './../../classes/Base'
import ITask from './../../interfaces/Itask'

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
		var dest = this.paths.app.dist.client.scripts.path;

		var promise = new Promise((resolve, reject) => {
			gulp.src(src, this.gOpts)
				.pipe(gulp.dest(dest))
				.on('end', () => resolve(true))
		})
		promise.then(() => {
			return console.log('copied js to client dist'.minor)
		})
		return promise;
	}

	/* Getters and Setters
	 **********************/
	private get gOpts(): {} {
		return { base: this.paths.app.src.client.scripts.path }
	}
	private get srcGlob(): string[] {
		return [
			`${this.paths.app.src.client.scripts.path}/**/*.js`,
		]
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


