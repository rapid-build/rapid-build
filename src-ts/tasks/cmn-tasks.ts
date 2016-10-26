/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base       from './../common/Base'
import ITask      from './../interfaces/ITask'
import cleanDist  from './common/clean/clean-dist';
import copyCSS    from './client/copy/copy-css';
import copyHtml   from './client/copy/copy-html';
import copyImages from './client/copy/copy-images';
import copyJS     from './client/copy/copy-js';
import copyLibs   from './client/copy/copy-libs';
import es6        from './client/compile/es6';
import coffee     from './client/compile/coffee';

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
	run() {
		return async(() => {
			var results = {
				cleanDist: await(cleanDist.run()),
				client: await({
					compile: {
						coffee: coffee.run(),
						es6:    es6.run()
					},
					copy: {
						css:    copyCSS.run(),
						html:   copyHtml.run(),
						images: copyImages.run(),
						js:     copyJS.run(),
						libs:   copyLibs.run()
					}
				})
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


