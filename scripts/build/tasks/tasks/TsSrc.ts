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
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, this.gOpts)
				.pipe(ts(this.opts))
				.pipe(this.pkgs.gulp.dest(this.PATHS.dist))
				.on('end', () => resolve())
		})
		promise.then(() => {
			return console.log('compiled typescript to dist'.minor)
		})
		return promise;
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on(this.EVENTS.change.ts.event, (_path) => {
			this.run(_path);
		});
	}

	/* Getters and Setters
	 **********************/
	private get opts(): {} {
		return {}
	}
	private get gOpts(): {} {
		return { base: this.PATHS.src }
	}
	private get srcGlob(): string[] {
		return [`${this.PATHS.src}/**/*.ts`]
	}

}

/* Export Singleton
 *******************/
export default TsSrc.getInstance()


