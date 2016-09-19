/* Singleton
 * @class CopySrc
 * @static
 *******************/
import Task from './../Task';

class CopySrc extends Task {
	private static instance: CopySrc;
	protected constructor() { super() }

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CopySrc()
	}

	run(src: string[] | string = [
		`${this.paths.src}/**/*.*`,
		`!${this.paths.src}/**/*.{coffee,ts}`
	]) {
		return new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src)
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('copied src to dist'.info)
		})
	}

}

export default CopySrc.getInstance()