/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Base         from './common/Base'
import devBuild     from './builds/dev-build'
import prodBuild    from './builds/prod-build'
import defaultBuild from './builds/default-build'

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