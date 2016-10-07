/* Singleton
 * @class Env
 * @static
 *************/
class Env {
	private static instance: Env;
	private envs: string[] = ['default', 'dev', 'prod']
	private _env: string = this.envs[0];

	/* Constructor
	 **************/
	private constructor() {
		this.setEnv()
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Env()
	}

	/* Methods
	 **********/
	isDefault(): boolean {
		return this.env === this.envs[0]
	}

	isDev(): boolean {
		return this.env === this.envs[1]
	}

	isProd(): boolean {
		return this.env === this.envs[2]
	}

	/* Getters and Setters
	 **********************/
	get env(): string {
		return this._env
	}

	// private because this is only set once in constructor
	private setEnv() {
		var _env: string = process.argv[2]
		if (!_env) return this
		_env = _env.toLowerCase()
		if (this.envs.indexOf(_env) === -1) return this
		this._env = _env
	 	return this
	}

}

/* Export Singleton
 *******************/
export default Env.getInstance()


