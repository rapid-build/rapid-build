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
			},
			server: {
				path: string;
			}
		},
		src: {
			path: string;
			client: {
				path: string;
			},
			server: {
				path: string;
			}
		}
	}
}