/* Singleton
 * @class Build
 * @static
 ***************/
require('./bootstrap/add-colors')
import { async, await } from 'asyncawait'
import Env       from './helpers/Env';
import DevBuild  from './builds/DevBuild';
import WatchTask from './tasks/tasks/WatchTask';

class Build {
	private static instance: Build;
	private constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Build()
	}

	private logBuildMsg() {
		console.log(`---------------------`.attn)
		console.log(`Running ${Env.env} Build`.attn)
		console.log(`---------------------`.attn)
	}

	private getBuild() {
		switch (true) {
			case Env.isProd():
				return DevBuild
			case Env.isDev():
				return DevBuild
			default:
				return DevBuild
		}
	}

	private runBuild = async(() => {
		try {
			var r1 = await(this.getBuild().run())
			console.log('PACKAGE DIST CREATED'.attn);
		}
		catch (e) {
			console.error('FAILED TO CREATE PACKAGE DIST'.error);
			console.error(`Error: ${e.message}`.error);
			r1 = e.message
		}
		return r1
	});

	private runWatch = async((fromWatch) => {
		if (!this.getBuild().watch) return
		if (fromWatch) return
		var r2 = await(WatchTask.run())
		return r2
	})

	/* TODO - Add Build Types
	 * Only have Dev right now
	 * @return promise
	 **************************/
	run(fromWatch?: boolean) {
		this.logBuildMsg();
		return async(() => {
			var r1 = await(this.runBuild())
			var r2 = await(this.runWatch(fromWatch))
			return r1
		})();
	}
}
export default Build.getInstance()


