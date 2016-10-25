/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base         from './classes/Base'
import devBuild     from './builds/devBuild'
import prodBuild    from './builds/prodBuild'
import defaultBuild from './builds/defaultBuild'

class Singleton extends Base {
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
			var results;
			switch (true) {
				case this.env.isDev:
					results = await(devBuild.run())
					break
				case this.env.isProd:
					results = await(prodBuild.run())
					break
				default:
					results = await(defaultBuild.run())
			}
			return results
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()