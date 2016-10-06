/* Singleton
 * @class CoffeeSrc
 * @static
 *******************/
import coffee  = require('gulp-coffee')
import plumber = require('gulp-plumber')
import Task       from './../Task';
import SrcEmitter from './../../events/SrcEmitter';

class CoffeeSrc extends Task {
	private static instance: CoffeeSrc;
	protected constructor() {
		super()
		this.addListeners();
	}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new CoffeeSrc()
	}

	private addListeners() {
		SrcEmitter.event.on('change coffee', (_path, base) => {
			console.log('COFFEE CHANGE:'.minor, _path.minor);
			this.run([_path], { base });
		});
	}

	private get opts() {
		return { bare: true }
	}

	run(src: string[] | string = [`${this.paths.src}/**/*.coffee`], gOpts={}) {
		return new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, gOpts)
				.pipe(plumber())
				.pipe(coffee(this.opts))
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('compiled coffee to dist'.info)
		})
	}

}

export default CoffeeSrc.getInstance()