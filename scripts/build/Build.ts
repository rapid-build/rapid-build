/* @class Singleton
 *******************/
import { async, await } from 'asyncawait'
import Env         from './helpers/Env';
import CmnTasks    from './tasks/CmnTasks';
import DevTasks    from './tasks/DevTasks';
import ProdTasks   from './tasks/ProdTasks';
import WatchBuild  from './tasks/tasks/WatchBuild';
import IBuildStack from "./interfaces/IBuildStack";

class Singleton {
	/* Constructor
	 **************/
	private static instance: Singleton;
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	run() {
		return async(() => {
			this.logBuildMsg();
			try {
				var result = await(this.runTasks());
				console.log('PACKAGE DIST CREATED'.attn);
			}
			catch (e) {
				console.error('FAILED TO CREATE PACKAGE DIST'.error);
				console.error(`Error: ${e.message}`.error);
				result = e.message
			}
			return result
		})()
	}

	/* Private Methods
	 ******************/
	private logBuildMsg() {
		if (Env.isWatchingBuild) console.log('')
		var msg = Env.isWatchingBuild ? 'Restart' : 'Running'
			msg += ' '
			msg += `Build: ${Env.env}`
		var div = Array(msg.length+1).join('-')
		console.log(`${div.attn}\n${msg.attn}\n${div.attn}`)
	}

	private runTasks() {
		return async(() => {
			var results: IBuildStack = {};

			switch (true) {
				case Env.isDefault:
					results.cmn = await(CmnTasks.run())
					break
				case Env.isDev:
					results.cmn = await(CmnTasks.run())
					results.dev = await(DevTasks.run())
					break
				case Env.isProd:
					results.cmn  = await(CmnTasks.run())
					results.prod = await(ProdTasks.run());
					break
			}

			if (Env.watchBuild && !Env.isWatchingBuild)
				results.watchBuild = await(WatchBuild.run());

			return results;
		})()
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()










