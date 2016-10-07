/* Singleton
 * @class CoffeeSrc
 * @static
 *******************/
import coffee  = require('gulp-coffee')
import plumber = require('gulp-plumber')
import Task from './../Task';

class CoffeeSrc extends Task {
	private static instance: CoffeeSrc;

	/* Constructor
	 **************/
	private constructor() {
		super()
		this.addListeners();
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CoffeeSrc()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, this.gOpts)
				.pipe(plumber())
				.pipe(coffee(this.opts))
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		promise.then(() => {
			return console.log('compiled coffee to dist'.info)
		})
		return promise;
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on('change coffee', (_path) => {
			console.log('COFFEE CHANGE:'.minor, _path.minor);
			this.run(_path);
		});
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return { bare: true }
	}
	private get gOpts(): {} {
		return { base: this.paths.src }
	}
	private get srcGlob(): string[] {
		return [`${this.paths.src}/**/*.coffee`]
	}

}

/* Export Singleton
 *******************/
export default CoffeeSrc.getInstance()


