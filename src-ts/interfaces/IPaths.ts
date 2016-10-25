/* RB PATHS INTERFACE
 *********************/
export interface IRbPaths {
	readonly rb: {
		path: string;
		dist: {
			path: string;
		}
	}
}

/* APP PATHS INTERFACE
 **********************/
export interface IAppPaths {
	readonly app: {
		path: string;
		dist: {
			path: string;
			client: {
				path: string;
				bower:        { path: string },
				images:       { path: string },
				libs:         { path: string },
				node_modules: { path: string },
				scripts:      { path: string },
				styles:       { path: string },
				test:         { path: string },
				typings:      { path: string },
				views:        { path: string }
			},
			server: { path: string; }
		},
		src: {
			path: string;
			client: {
				path: string;
				bower:        { path: string },
				images:       { path: string },
				libs:         { path: string },
				node_modules: { path: string },
				scripts:      { path: string },
				styles:       { path: string },
				test:         { path: string },
				typings:      { path: string },
				views:        { path: string }
			},
			server: { path: string; }
		}
	}
}