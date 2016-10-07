/* Singleton
 * @class TsSrc
 * @static
 *******************/
import ts = require('gulp-typescript')
import Task from './../Task';

class TsSrc extends Task {
	private static instance: TsSrc;

	/* Constructor
	 **************/
	private constructor() {
		super()
		this.addListeners();
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new TsSrc()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		return new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, this.gOpts)
				.pipe(ts(this.opts))
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('compiled typescript to dist'.info)
		})
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on('change ts', (_path) => {
			console.log('TS CHANGE:'.minor, _path.minor);
			this.run(_path);
		});
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return {}
	}
	private get gOpts(): {} {
		return { base: this.paths.src }
	}
	private get srcGlob(): string[] {
		return [`${this.paths.src}/**/*.ts`]
	}

}

/* Export Singleton
 *******************/
export default TsSrc.getInstance()


