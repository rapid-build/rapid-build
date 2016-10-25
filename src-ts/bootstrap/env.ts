/* @class Singleton
 *******************/
import BUILDS from '../constants/BUILDS'

class Singleton {
	private static instance: Singleton;
	private _name: string = BUILDS.types.default;

	/* Constructor
	 **************/
	private constructor() {
		BUILDS // init BUILDS
		this.set()
		// console.log('env set'.minor)
	}
	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Singleton()
	}

	/* Public Methods
	 *****************/
	private set(buildType: string = process.argv[2]): this { // called in bootstrap.ts
		if (typeof buildType !== 'string') return this
		buildType = buildType.toLowerCase()
		for (let [key, val] of Object.entries(BUILDS.types)) {
			if (val !== buildType) continue
			this._name = val
			break
		}
	}

	/* Getters and Setters
	 **********************/
	get name(): string {
		return this._name
	}
	get isDefault(): boolean {
		return BUILDS.default.indexOf(this._name) !== -1
	}
	get isDev(): boolean {
		return BUILDS.dev.indexOf(this._name) !== -1
	}
	get isProd(): boolean {
		return BUILDS.prod.indexOf(this._name) !== -1
	}
	get isTest(): boolean {
		return BUILDS.test.indexOf(this._name) !== -1
	}
}

/* Export Singleton
 *******************/
export default Singleton.getInstance()