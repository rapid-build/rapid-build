/* Singleton
 * @class Build
 * @static
 ***************/
import Env      from './helpers/Env';
import DevBuild from './builds/DevBuild';

class Build {
	private static instance: Build;
	private constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Build()
	}

	/* TODO - Add Build Types
	 * Only have Dev right now
	 **************************/
	run(): Promise<void> {
		console.log(`Running ${Env.env} Build`.attn)
		console.log(`---------------------`.attn)

		switch (true) {
			case Env.isProd():
				return DevBuild.run(true)

			case Env.isDev():
				return DevBuild.run(true)

			default:
				return DevBuild.run(true)
		}
	}
}

export default Build.getInstance()