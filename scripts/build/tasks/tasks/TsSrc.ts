/* Singleton
 * @class TsSrc
 * @static
 *******************/
import ts = require('gulp-typescript')
import Task       from './../Task';
import SrcEmitter from './../../events/SrcEmitter';

class TsSrc extends Task {
	private static instance: TsSrc;
	protected constructor() {
		super()
		this.addListeners();
	}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new TsSrc()
	}

	private addListeners() {
		SrcEmitter.event.on('change ts', (_path, base) => {
			console.log('TS CHANGE:'.minor, _path.minor);
			this.run([_path], { base });
		});
	}

	private get opts() {
		return {}
	}

	run(src: string[] | string = [`${this.paths.src}/**/*.ts`], gOpts={}) {
		return new this.pkgs.Promise((resolve, reject) => {
			this.pkgs.gulp.src(src, gOpts)
				.pipe(ts(this.opts))
				.pipe(this.pkgs.gulp.dest(this.paths.dist))
				.on('end', () => resolve())
		})
		.then(() => {
			return console.log('compiled typescript to dist'.info)
		})
	}

}

export default TsSrc.getInstance()