/* PATHS CONSTANT
 *****************/
import path = require('path')
import { IRbPaths, IAppPaths } from './../interfaces/IPaths'
var join = path.join
const RB:  string = path.join(__dirname, '..', '..')
const APP: string = process.cwd()

/* RB PATHS
 ***********/
const RB_PATHS: IRbPaths = {
	rb: {
		path: RB,
		dist: {
			path: join(RB, 'dist')
		}
	}
}

/* APP PATHS
 ************/
const APP_PATHS: IAppPaths = {
	app: {
		path: APP,
		dist: {
			path: join(APP, 'dist'),
			client: {
				path: join(APP, 'dist', 'client')
			},
			server: {
				path: join(APP, 'dist', 'server')
			}
		},
		src: {
			path: join(APP, 'src'),
			client: {
				path: join(APP, 'src', 'client')
			},
			server: {
				path: join(APP, 'src', 'server')
			}
		}
	}
}

/* Export It
 ************/
const PATHS = Object.assign(RB_PATHS, APP_PATHS) // merge objects
export default PATHS