/* @class Singleton
 *******************/
class Singleton {
	private static instance: Singleton;
	private envs: string[] = ['default', 'dev', 'prod']
	private _env: string = this.envs[0];
	private _watchBuild: boolean = false;
	private readonly WATCH_BUILD: string = 'watch';

	/* Constructor
	 **************/
	private constructor() {
		this.setEnv()
		this.setWatchBuild()
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Private Methods
	 ******************/
	private setEnv() { // set once in constructor
		var _env: string = process.argv[2]
		if (!_env) return this
		_env = _env.toLowerCase()
		if (this.envs.indexOf(_env) === -1) return this
		this._env = _env
	 	return this
	}

	private setWatchBuild() { // set once in constructor
		var args = process.argv;
		if (args.length < 3) return this
		for (let i = 0; i < args.length; i++) {
			if (i < 2) continue;
			if (args[i].toLowerCase() != this.WATCH_BUILD) continue
			this._watchBuild = true;
			break;
		}
		return this
	}

	/* Getters and Setters
	 **********************/
	get env(): string {
		return this._env
	}

	get isDefault(): boolean {
		return this.env === this.envs[0]
	}

	get isDev(): boolean {
		return this.env === this.envs[1]
	}

	get isProd(): boolean {
		return this.env === this.envs[2]
	}

	get isWatchingBuild(): boolean {
		return process.env['RB_WATCHING_BUILD'] === 'true';
	}

	get watchBuild(): boolean {
		return this._watchBuild
	}

	set isWatchingBuild(val: boolean) { // set in WatchBuild.ts
		process.env['RB_WATCHING_BUILD'] = val ? 'true' : 'false';
	}

}

/* Export Singleton
 *******************/
export default Singleton.getInstance()


