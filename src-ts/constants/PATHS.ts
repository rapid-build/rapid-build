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
				path: join(APP, 'dist', 'client'),
				bower:        { path: join(APP, 'dist', 'client', 'bower_components') },
				images:       { path: join(APP, 'dist', 'client', 'images') },
				libs:         { path: join(APP, 'dist', 'client', 'libs') },
				node_modules: { path: join(APP, 'dist', 'client', 'node_modules') },
				scripts:      { path: join(APP, 'dist', 'client', 'scripts') },
				styles:       { path: join(APP, 'dist', 'client', 'styles') },
				test:         { path: join(APP, 'dist', 'client', 'test') },
				typings:      { path: join(APP, 'dist', 'client', 'typings') },
				views:        { path: join(APP, 'dist', 'client', 'views') }
			},
			server: {
				path: join(APP, 'dist', 'server')
			}
		},
		src: {
			path: join(APP, 'src'),
			client: {
				path: join(APP, 'src', 'client'),
				bower:        { path: join(APP, 'src', 'client', 'bower_components') },
				images:       { path: join(APP, 'src', 'client', 'images') },
				libs:         { path: join(APP, 'src', 'client', 'libs') },
				node_modules: { path: join(APP, 'src', 'client', 'node_modules') },
				scripts:      { path: join(APP, 'src', 'client', 'scripts') },
				styles:       { path: join(APP, 'src', 'client', 'styles') },
				test:         { path: join(APP, 'src', 'client', 'test') },
				typings:      { path: join(APP, 'src', 'client', 'typings') },
				views:        { path: join(APP, 'src', 'client', 'views') }
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



