/* Singleton
 * @class Build
 * @static
 ***************/
require('./bootstrap/add-colors')
import { async, await } from 'asyncawait'
import DevBuild         from './builds/DevBuild';
import Env              from './helpers/Env';
import WatchBuild       from './tasks/tasks/WatchBuild';

class Build {
	private static instance: Build;

	/* Constructor
	 **************/
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Build()
	}

	/* Public Methods
	 *****************/
	run(fromWatch?: boolean) {
		/* TODO - Add Build Types
		 * Only have Dev right now
		 * @return promise
		 **************************/
		this.logBuildMsg(fromWatch);
		return async(() => {
			var r1 = await(this.runBuild())
			var r2 = await(this.runBuildWatch(fromWatch))
			return r1
		})();
	}

	/* Private Methods
	 ******************/
	private logBuildMsg(fromWatch) {
		if (fromWatch) console.log('')
		var msg = fromWatch ? 'Restart' : 'Running'
			msg += ' '
			msg += `Build: ${Env.env}`
		var div = Array(msg.length+1).join('-')
		console.log(`${div.attn}\n${msg.attn}\n${div.attn}`)
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

	private runBuildWatch = async((fromWatch) => {
		if (!this.getBuild().watch) return
		if (fromWatch) return
		var r1 = await(WatchBuild.run())
		return r1
	})
}

/* Export Singleton
 *******************/
export default Build.getInstance()










