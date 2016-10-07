/* Singleton
 * @class CopySrc
 * @static
 *******************/
import Task from './../Task';

class CopySrc extends Task {
	private static instance: CopySrc;

	/* Constructor
	 **************/
	private constructor() { super() }
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CopySrc()
	}

	/* Public Methods
	 *****************/
	run(src: string[] | string = this.srcGlob) {
		return new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, this.gOpts)
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('copied src to dist'.info)
		})
	}

	/* Getters and Setters
	 **********************/
	private get gOpts(): {} {
		return { base: this.paths.src }
	}
	private get srcGlob(): string[] {
		return [
			`${this.paths.src}/**/*.*`,
			`!${this.paths.src}/**/*.{coffee,ts}`
		]
	}

}

/* Export Singleton
 *******************/
export default CopySrc.getInstance()


