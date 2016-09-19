/* Singleton
 * @class ModuleCache
 * @static
 *********************/
import path = require('path')

class ModuleCache {
	private static instance: ModuleCache;

	private constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new ModuleCache()
	}

	get(_path: string) {
		return require.cache[_path]
	}

	getIds() {
		return Object.keys(require.cache);
	}

	delete(_path: string): boolean {
		var nModule = this.get(_path);
		if (!nModule) return false // if not cached
		// recursively delete it's children too
		for (let child of nModule.children) {
			if (child.id.indexOf('node_modules') !== -1) continue
			this.delete(child.id)
		}
		delete require.cache[_path]
		return true
	}
}

export default ModuleCache.getInstance()