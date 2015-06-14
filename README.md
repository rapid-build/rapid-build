# rapid-build
**Developing**, not for use yet.  
**Requirements**: [npm](http://npmjs.org/) and [Node.js](http://nodejs.org/) version >= 0.10.0

*More and better documentation coming real soon!*

## Installation
```bash
$ npm install rapid-build
```

## How To Use
**As a function:**

```javascript
/**
 * Init rapid-build.
 * Rapid uses smart defaults.
 * Pass in options if you need customization.
 * *******************************************/
var options = {}
var rapid = require('rapid-build')(options) // init rapid, pass in options here

/**
 * After initializing rapid, execute it to kick off the build.
 * 1 optional param (the build mode), values are: nothing, 'dev' or 'prod'.
 * Rapid has 3 build modes: default, dev and prod (see build modes).
 */
rapid().then(function() {
	console.log('whatever you want') // probably won't need to do anything
})
```

**Or as a gulp task:** ([gulp required](http://gulpjs.com/))

```javascript
/**
 * Steps if you are using gulp.
 * In your gulpfile.js init rapid-build and
 * pass in gulp (pass in options too if you need customization).
 * 3 build tasks become available after initializing rapid (see build modes).
 * Build tasks are: 'rapid-build', 'rapid-build:dev' and 'rapid-build:prod'
 * ***************************************************************************/
var gulp = require('gulp')
var options = {}
require('rapid-build')(gulp, options)

// execute rapid via a gulp task dependency
gulp.task('default', ['rapid-build'])

// or from the terminal type one of the 3:
gulp rapid-build
gulp rapid-build:dev
gulp rapid-build:prod
```

### Options API
```coffeescript
# Example: options.ports.server = 5000
# Options is an object, you can set the following properties:
# -----------------------------------------------------------
# dist.dir                                     = (string)  defaults to 'dist'
# dist.client.dir                              = (string)  defaults to 'client'
# dist.client[images|scripts|styles|views].dir = (string)  defaults to property name
# dist.client.bower.dir                        = (string)  defaults to 'bower_components'
# dist.client.libs.dir                         = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# dist.server.dir                              = (string)  defaults to 'server'
# dist.server.file                             = (string)  defaults to 'routes.js'
# src.dir                                      = (string)  defaults to 'src'
# src.client.dir                               = (string)  defaults to 'client'
# src.client[images|scripts|styles|views].dir  = (string)  defaults to property name
# src.client.bower.dir                         = (string)  defaults to 'bower_components'
# src.client.libs.dir                          = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# src.server.dir                               = (string)  defaults to 'server'
# ports.server                                 = (int)     defaults to 3000
# ports.reload                                 = (int)     defaults to 3001
# order[scripts|styles][first|last]            = (array of strings) = file paths
# angular.modules                              = (array of strings) = additional angular modules to load, already loaded are ['ngResource', 'ngRoute', 'ngSanitize']
# angular.moduleName                           = (string)  defaults to 'app' = application module name, value for ng-app
# angular.version                              = (string)  defaults to '1.x' = semver version required
# angular.templateCache.dev.enable             = (boolean) defaults to false = use template cache when running default and dev task
# angular.templateCache.useAbsolutePaths       = (boolean) defaults to false = prefix template urls with a '/'
# spa.title                                    = (string)  defaults to package.json name or 'Application' = html title tag value
# spa.description                              = (string)  defaults to package.json description = html meta description tag value
# spa.src.file                                 = (string)  defaults to 'spa.html' = set if you want to use your own spa file and not the build system's (file must be located in your client src directory)
# spa.src.dir                                  = (string)  defaults to null = set if you are using your own spa file and that file is located in a directory in your client src directory
# spa.dist.file                                = (string)  defaults to spa.src.file or 'spa.html' = provide if you want the dist spa file to be named differently, example: 'index.html'
# spa.exclude.styles                           = (boolean) defaults to false = set to true to exclude styles from the spa file
# spa.exclude.scripts                          = (boolean) defaults to false = set to true to exclude scripts from the spa file
# ==============================================================================================================================================================================================================
```

### Build Modes
**Common Tasks (all 3 builds do the following tasks first):**
1. install bower components (if they aren't installed)
2. copy the following files to the dist directory
	* css - (client)
	* images - (client)
	* js - (client and server)
	* html - (client)
	* libs - (client) (everything in the libs directory)
	* bower components - (client) (files in every bower.json's main prop)
	* compile then copy to dist
		* coffee -> js - (client and server)
		* es6 -> js - (client and server)
		* less -> css - (client)

**Default Build:**
1. run common tasks (see above)
2. build the spa.html file then copy to dist/client/
3. start the server
4. open the browser

**Dev Build:**
1. run common tasks (see above)
2. build the spa.html file then copy to dist/client/
3. start the server
4. open the browser
5. fireup the file watchers (on saving a file, the browser will refresh)

**Prod Build:**
1. run common tasks (see above)
2. concatenate application files
..* css
..* js
3. minify the application files
..* css
..* js
4. prepend libs to the application file
..* css
..* js
5. prepend bower components to the application file
..* css (styles.min.css created)
..* js (scripts.min.css created)
6. build the spa.html file
7. minify the spa.html file
8. minify server js files
9. start the server

#### CHANGELOG
Releases are documented here [changelog](https://github.com/jyounce/rapid-build/blob/master/CHANGELOG.md).

## Develop Rapidly!
![Shake and Bake!](docs/shake-and-bake.jpg)











