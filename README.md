# rapid-build
**Developing**, not for use yet.  
**Requirements**: [npm](http://npmjs.org/) and [Node.js](http://nodejs.org/) version >= 0.10.0  

Releases are documented here [changelog](https://github.com/jyounce/rapid-build/blob/master/CHANGELOG.md).  
More and better documentation *coming real soon*!

## Installation
```bash
$ npm install rapid-build
```

## Description
*Rapidly* develop distributable client and server side packages/folders.
rapid-build currently supports the following technologies:
* languages
	* [css](https://developer.mozilla.org/en-US/docs/Web/CSS) and [less](http://lesscss.org/) (client)
	* [html](https://developer.mozilla.org/en-US/docs/Web/HTML) (client)
	* [js](https://developer.mozilla.org/en-US/docs/Web/JavaScript), [es6](https://babeljs.io/) and [coffeescript](http://coffeescript.org/) (client and server)
* frameworks
	* [angular](https://angularjs.org/) (client)
	* [express](http://expressjs.com/) (server)
* package managers
	* [bower](http://bower.io/) (client)

##### Key concepts:
* src
	* this is where you develop, place your working files here
	* these files should be under a [version control system](http://guides.beanstalkapp.com/version-control/intro-to-version-control.html)
	  ([ex](https://github.com/ "Example: GitHub that uses Git"))
* dist
	* this is where your distributable packages/folders will be built
	* once built you can ship them off to places like a webserver
	* these packages should not be under version control
		* instead use a [ci system](http://www.thoughtworks.com/continuous-integration "Continuous Integration System")
		  ([ex](https://travis-ci.org/ "Example: Travis CI")) to build and deploy your packages
* client
	* directory for all your
	  [client side](http://programmers.stackexchange.com/questions/171203/what-are-the-differences-between-server-side-and-client-side-programming)
	  code
* server
	* directory for all your
	  [server side](http://programmers.stackexchange.com/questions/171203/what-are-the-differences-between-server-side-and-client-side-programming)
	  code


## How To Use
##### As a function:

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
 * 1 optional param (the build mode), values are: nothing, 'dev', 'test' or 'prod'.
 * Rapid has 4 build modes: default, dev, test and prod (see build modes).
 */
rapid().then(function() {
	console.log('whatever you want') // probably won't need to do anything
})
```

##### Or as a gulp task: ([gulp required](http://gulpjs.com/))

```javascript
/**
 * Steps if you are using gulp.
 * In your gulpfile.js init rapid-build and
 * pass in gulp (pass in options too if you need customization).
 * 3 build tasks become available after initializing rapid (see build modes).
 * Build tasks are: 'rapid-build', 'rapid-build:dev', 'rapid-build:test' and 'rapid-build:prod'
 * *********************************************************************************************/
var gulp = require('gulp')
var options = {}
require('rapid-build')(gulp, options)

// execute rapid via a gulp task dependency
gulp.task('default', ['rapid-build'])

// or from the terminal type one of the 3:
gulp rapid-build
gulp rapid-build:dev
gulp rapid-build:test
gulp rapid-build:prod
```

## Options API
```coffeescript
# Example: options.ports.server = 5000
# Options is an object, you can set the following properties:
# -----------------------------------------------------------
# dist.dir                                          = (string)  defaults to 'dist'
# dist.client.dir                                   = (string)  defaults to 'client'
# dist.client[images|scripts|styles|test|views].dir = (string)  defaults to property name
# dist.client.bower.dir                             = (string)  defaults to 'bower_components'
# dist.client.libs.dir                              = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# dist.server.dir                                   = (string)  defaults to 'server'
# dist.server.file                                  = (string)  defaults to 'routes.js'
# src.dir                                           = (string)  defaults to 'src'
# src.client.dir                                    = (string)  defaults to 'client'
# src.client[images|scripts|styles|test|views].dir  = (string)  defaults to property name
# src.client.bower.dir                              = (string)  defaults to 'bower_components'
# src.client.libs.dir                               = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# src.server.dir                                    = (string)  defaults to 'server'
# ports.server                                      = (int)     defaults to 3000
# ports.reload                                      = (int)     defaults to 3001
# order[scripts|styles][first|last]                 = (array of strings) = file paths
# angular.modules                                   = (array of strings) = additional angular modules to load, already loaded are ['ngResource', 'ngRoute', 'ngSanitize'] and 'ngMockE2E' based on angular.httpBackend options
# angular.moduleName                                = (string)  defaults to 'app' = application module name, value for ng-app
# angular.version                                   = (string)  defaults to '1.x' = semver version required
# angular.httpBackend.dev                           = (boolean) defaults to false = set to true to enable httpBackend for dev and default build
# angular.httpBackend.prod                          = (boolean) defaults to false = set to true to enable httpBackend for prod build
# angular.httpBackend.dir                           = (string)  defaults to 'mocks' = directory inside your client scripts directory
# angular.templateCache.dev                         = (boolean) defaults to false = use template cache when running default and dev task
# angular.templateCache.useAbsolutePaths            = (boolean) defaults to false = prefix template urls with a '/'
# spa.title                                         = (string)  defaults to package.json name or 'Application' = html title tag value
# spa.description                                   = (string)  defaults to package.json description = html meta description tag value
# spa.src.file                                      = (string)  defaults to 'spa.html' = set if you want to use your own spa file and not the build system's (file must be located in your client src directory)
# spa.src.dir                                       = (string)  defaults to null = set if you are using your own spa file and that file is located in a directory in your client src directory
# spa.dist.file                                     = (string)  defaults to spa.src.file or 'spa.html' = provide if you want the dist spa file to be named differently, example: 'index.html'
# spa.placeholders                                  = (array of strings) = set to retain spa file placeholders, optional values are: ['scripts', 'styles', 'description', 'moduleName', 'title'] or ['all']
# minify.css.styles                                 = (boolean) defaults to true = for prod build, minify the css
# minify.css.splitMinFile                           = (boolean) defaults to true = for prod build, task for ie9 and below, split styles.min.css into multiple files if selector count > 4,095
# minify.html.views                                 = (boolean) defaults to true = for prod build, minify the html
# minify.html.templateCache                         = (boolean) defaults to true = for prod build, use the template cache
# minify.js.scripts                                 = (boolean) defaults to true = for prod build, minify the js
# minify.js.mangle                                  = (boolean) defaults to true = for prod build, mangle the names in the js
# minify.spa.file                                   = (boolean) defaults to true = for prod build, minify the spa.html file
# minify.cacheBust                                  = (boolean) defaults to true = for prod build, ensures the user always receives the latest files, adds an md5 checksum to the client files before their extension
# exclude.angular.files                             = (boolean) defaults to false = set to true to exclude the angular files that come with rapid-build from dist (lib and modules)
# exclude.from.cacheBust                            = (array of strings) = file paths: exclude files from the cache bust
# exclude.from.minFile[scripts|styles]              = (array of strings) = file paths: exclude script or style files from automatically being generated in the scripts.min.js or styles.min.css file
# exclude.from.spaFile[scripts|styles]              = (array of strings) = file paths: exclude script or style files from automatically being generated in the spa.html file
# test.browsers                                     = (array of browser names) = phantomjs will run by default, optional browser names are ['chrome', 'firefox', 'ie', 'safari'] 
# =============================================================================================================================================================================================================================
```

## Build Modes
#### Common Tasks (all 4 builds do the following tasks first):
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

#### Default Build:
1. run common tasks (see above)
2. build the spa.html file then copy to dist/client/
3. start the server
4. open the browser

#### Dev Build:
1. run common tasks (see above)
2. build the spa.html file then copy to dist/client/
3. start the server
4. open the browser
5. fireup the file watchers (on saving a file, the browser will refresh)

#### Test Build:
1. run common tasks (see above)
2. copy test scripts to dist/client/
3. run tests in [PhantomJS](http://phantomjs.org/)

#### Prod Build:
1. run common tasks (see above)
2. minify the application files
	* css
	* html
	* js
3. concatenate files
	* css (styles.min.css created)
	* js (scripts.min.css created)
4. build the spa.html file
5. minify the spa.html file
6. cache bust the files (client)
7. minify server js files
8. start the server

## Develop Rapidly!
![Shake and Bake!](docs/shake-and-bake.jpg "Shake n' Bake!")











