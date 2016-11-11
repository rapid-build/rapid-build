/* @class Less
 * @constructor
 ***************/
import { async, await } from 'asyncawait'
import path  = require('path')
import gulp  = require('gulp')
import Vinyl = require('vinyl')
import gVinyl from './../plugins/gulp-vinyl'

interface IImportMap {
	[filePath: string]: string[]; // file import paths
}

class Less {
	private importMap: IImportMap = {};
	private cmtsReg   = /\/\/.*|\/\*[\s\S]+?\*\//g
	private importReg = /@import\s*?(?!\s*?\(css\)*?).*?['"]+?(.*?)['"]/g

	/* Public Methods
	 *****************/
	getSrc(src: string[] | string) {
		return async(() => {
			await(this.setImportMap(src))
			var imports = this.getImports('ignored')
			imports     = this.negateImports(imports)
			src         = [].concat(src, imports)
			return src
		})()
	}

	/* Private Methods
	 ******************/
	private negateImports(imports: string[]): string[] {
		for (let i in imports)
			imports[i] = `!${imports[i]}`

		return imports
	}

	private getImports(ignored): string[] {
		var uImports = {}; // unique imports
		for (let [file, imports] of Object.entries(this.importMap)) {
			if (!imports.length) continue;
			for (let i in imports)
				uImports[imports[i]] = i
		}
		return Object.keys(uImports);
	}

	private setImportMap(src) {
		return new Promise((resolve, reject) => {
			gulp.src(src)
				.pipe(gVinyl())
				.on('data', (file: Vinyl) => {
					this.processFile(file)
				})
				.on('end', () => {
					resolve(true)
					// setTimeout(() => { resolve(true); }, 3000);
				})
		})
	}

	private processFile(file: Vinyl): this {
		var imports = this.getFileImports(file);
		if (!imports.length) return this;
		this.importMap[file.path] = imports;
		// console.log('Import Map:'.attn);
		// console.log(this.importMap);
		return this
	}

	private getFileImports(file: Vinyl): string[] {
		var imports: string[] = [];
		if (file.isNull()) return imports;

		var contents = file.contents.toString();
		if (!contents) return imports;
		contents = this.stripCmts(contents) // first strip the comments

		var matches: RegExpExecArray | null;
		while ((matches = this.importReg.exec(contents)) !== null) {
			let match = matches[1];
			if (match.indexOf('//') !== -1) continue;
			let _path = path.resolve(file.dirname, match);
			let ext   = path.extname(_path)
			_path    += !ext ? '.less' : '';
			imports.push(_path)
		}
		return imports
	}

	private stripCmts(fileContents: string): string {
		return fileContents.replace(this.cmtsReg, '');
	}
}

/* Export It!
 *************/
export default Less


