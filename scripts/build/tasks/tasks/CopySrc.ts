/* Singleton
 * @class CopySrc
 * @static
 *******************/
import Vinyl = require('vinyl')
import Task from './../Task';

class CopySrc extends Task {
	private static instance: CopySrc;

	/* Constructor
	 **************/
	private constructor() {
		super()
		this.addListeners();
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CopySrc()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		var promise = new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, this.gOpts)
				.pipe(this.pkgs.gulp.dest(this.PATHS.dist))
				.on('end', () => resolve())
		})
		promise.then(() => {
			return console.log('copied src to dist'.minor)
		})
		return promise;
	}

	/* Private Methods
	 ******************/
	private addListeners() {
		this.eventEmitter.on(this.EVENTS.change.src, (file: Vinyl) => {
			this.run(file.path);
		});

		this.eventEmitter.on(this.EVENTS.add.src, (file: Vinyl) => {
			this.run(file.path);
		});

		this.eventEmitter.on(this.EVENTS.unlink.src, (file: Vinyl) => {
			var _path = new this.utils.Path(file.path).srcToDist().path;
			this.tasks.CleanDist.run(_path)
		});
	}

	/* Getters and Setters
	 **********************/
	private get gOpts(): {} {
		return { base: this.PATHS.src }
	}
	private get srcGlob(): string[] {
		return [
			`${this.PATHS.src}/**/*.*`,
			`!${this.PATHS.src}/**/*.{coffee,ts}`
		]
	}

}

/* Export Singleton
 *******************/
export default CopySrc.getInstance()


