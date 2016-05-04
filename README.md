# rapid-build
**Requirements**: [npm](http://npmjs.org/) and [Node.js](http://nodejs.org/) version >= 4.0.0  

Releases are documented here [changelog](https://github.com/jyounce/rapid-build/blob/master/CHANGELOG.md).  
More and better documentation *coming real soon*!

## Installation
If installing globally you may need to set your [NODE_PATH](https://nodejs.org/api/modules.html#modules_loading_from_the_global_folders).
```bash
$ npm install rapid-build
```

## Description
*Rapidly* develop distributable client and server side packages/folders.
rapid-build currently supports the following technologies:
* languages
	* [css](https://developer.mozilla.org/en-US/docs/Web/CSS), [less](http://lesscss.org/) and [sass](http://sass-lang.com/) (client)
	* [html](https://developer.mozilla.org/en-US/docs/Web/HTML) (client)
	* [js](https://developer.mozilla.org/en-US/docs/Web/JavaScript), [es6](https://babeljs.io/) and [coffeescript](http://coffeescript.org/) (client and server)
* frameworks
	* [angular](https://angularjs.org/) (client)
	* [karma](http://karma-runner.github.io/) (client testing)
	* [jasmine](http://jasmine.github.io/) (client and server testing)
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
 * build.js
 * Init rapid-build.
 * Rapid uses smart defaults.
 * Pass in options if you need customization.
 * *******************************************/
var options = {}
var rapid = require('rapid-build')(options) // init rapid, pass in options here

/**
 * After initializing rapid, execute it to kick off the build.
 * 1 optional param (the build mode), values are: nothing, 'dev', 'prod' or 'test'.
 * Rapid has 4 build modes: default, dev, prod and test (see build modes).
 */
rapid().then(function() {
	console.log('whatever you want') // probably won't need to do anything
})
```

##### Or as a gulp task: ([gulp required](http://gulpjs.com/))

```javascript
/**
 * gulpfile.js - steps if you are using gulp.
 * Init rapid-build and pass in gulp (pass in options too if you need customization).
 * 4 build tasks become available after initializing rapid (see build modes).
 * Build tasks are: 'rapid-build', 'rapid-build:dev', 'rapid-build:prod' and 'rapid-build:test'
 * *********************************************************************************************/
var gulp = require('gulp')
var options = {}
require('rapid-build')(gulp, options)

// execute rapid via a gulp task dependency
gulp.task('default', ['rapid-build'])

// or from the terminal type one of the 6:
gulp rapid-build
gulp rapid-build:test
gulp rapid-build:dev
gulp rapid-build:prod
gulp rapid-build:prod:server
gulp rapid-build:prod:test
```

## Directory Structure
Everthing is optional besides nodes_modules/, build.js and package.json.
```
src/ 
├── client/
│   ├── bower_components/ (generated folder via bower.json)
│   ├── images/
│   │   └── **/*.{gif,jpg,jpeg,png}
│   ├── libs/
│   │   └── **/*.*
│   ├── scripts/
│   │   └── **/*.{coffee,es6,js}
│   ├── styles/
│   │   └── **/*.{css,less,sass,scss}
│   ├── test/
│   │   └── **/*.{coffee,es6,js}
│   ├── views/
│   │   └── **/*.html
│   └── spa.html (optional, see options.spa.src.filePath)
└── server/
    ├── test/
    │   └── **/*.{coffee,es6,js}
    └── routes.{coffee,es6,js} (see options.dist.server.fileName)
nodes_modules/ (generated folder via package.json)
bower.json
build.js (see how to use)
package.json
```

## Options API
```coffeescript
# Example: options.ports.server = 5000
# Options is an object, you can set the following properties:
# -----------------------------------------------------------
# build[client|server]                              = (boolean) both default to true = atleast one is required to be true
# dist.dir                                          = (string)  defaults to 'dist'
# dist.client.dir                                   = (string)  defaults to 'client'
# dist.client[images|scripts|styles|test|views].dir = (string)  defaults to property name
# dist.client.bower.dir                             = (string)  defaults to 'bower_components'
# dist.client.libs.dir                              = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# dist.server.dir                                   = (string)  defaults to 'server'
# dist.server.test.dir                              = (string)  defaults to 'test'
# dist.server.fileName                              = (string)  defaults to 'routes.js': this is the server's entry script
# src.dir                                           = (string)  defaults to 'src'
# src.client.dir                                    = (string)  defaults to 'client'
# src.client[images|scripts|styles|test|views].dir  = (string)  defaults to property name
# src.client.bower.dir                              = (string)  defaults to 'bower_components'
# src.client.libs.dir                               = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# src.server.dir                                    = (string)  defaults to 'server'
# src.server.test.dir                               = (string)  defaults to 'test'
# ports.server                                      = (int)     defaults to 3000, web server port
# ports.reload                                      = (int)     defaults to 3001, browsersync server port 
# ports.reloadUI                                    = (int)     defaults to 3002, browsersync's user-interface server port 
# ports.test                                        = (int)     defaults to 9876, karma server port
# order[scripts|styles][first|last]                 = (array of strings) = file paths
# angular.modules                                   = (array of strings) = additional angular modules to load, already loaded are ['ngResource', 'ngRoute', 'ngSanitize'] and 'ngMockE2E' based on angular.httpBackend options
# angular.moduleName                                = (string)  defaults to 'app' = application module name, value for ng-app
# angular.version                                   = (string)  defaults to '1.x' = semver version required
# angular.httpBackend.dev                           = (boolean) defaults to false = set to true to enable httpBackend for dev and default build
# angular.httpBackend.prod                          = (boolean) defaults to false = set to true to enable httpBackend for prod build
# angular.httpBackend.dir                           = (string)  defaults to 'mocks' = directory inside your client scripts directory
# angular.templateCache.dev                         = (boolean) defaults to false = use template cache when running default and dev task
# angular.templateCache.urlPrefix                   = (string)  prefix for template urls
# angular.templateCache.useAbsolutePaths            = (boolean) defaults to false = prefix template urls with a '/'
# angular.ngFormify                                 = (boolean) defaults to false = set to true to replace all html form tags with ng:form in client dist, useful if your application is going to be wrapped in a global form
# spa.title                                         = (string)  defaults to package.json name or 'Application' = html title tag value
# spa.description                                   = (string)  defaults to package.json description = html meta description tag value
# spa.src.filePath                                  = (string)  set if you want to use your own spa file and not the build system's (file must be located in your client src directory)
# spa.dist.fileName                                 = (string)  defaults to file name of spa.src.filePath or 'spa.html' = provide if you want the dist spa file to be named differently, example: 'index.html'
# spa.placeholders                                  = (array of strings) = set to retain spa file placeholders, optional values are: ['clickjacking', 'description', 'moduleName', 'scripts', 'styles', 'title'] or ['all']
# minify.css.styles                                 = (boolean) defaults to true = for prod build, minify the css
# minify.css.fileName                               = (string)  defaults to 'styles.min.css'
# minify.css.splitMinFile                           = (boolean) defaults to true = for prod build, task for ie9 and below, split styles.min.css into multiple files if selector count > 4,095
# minify.html.views                                 = (boolean) defaults to true = for prod build, minify the html
# minify.html.templateCache                         = (boolean) defaults to true = for prod build, use the template cache
# minify.html.options                               = (object)  defaults to { collapseWhitespace: true, removeComments: true, removeEmptyElements: false, removeEmptyAttributes: false } for details see: https://git.io/vVyAC
# minify.js.scripts                                 = (boolean) defaults to true = for prod build, minify the js
# minify.js.fileName                                = (string)  defaults to 'scripts.min.js'
# minify.js.mangle                                  = (boolean) defaults to true = for prod build, mangle the names in the js
# minify.spa.file                                   = (boolean) defaults to true = for prod build, minify the spa.html file
# minify.cacheBust                                  = (boolean) defaults to true = for prod build, ensures the user always receives the latest files, adds an md5 checksum to the client files before their extension
# exclude.spa                                       = (boolean) defaults to false = set to true to exclude spa.html from client dist
# exclude.angular.files                             = (boolean) defaults to false = set to true to exclude the angular files that come with rapid-build from dist (lib and modules)
# exclude.angular.modules                           = (boolean) defaults to false = set to true to exclude injecting the angular modules that come with rapid-build ['ngResource', 'ngRoute', 'ngSanitize']
# exclude.default.client.files                      = (boolean) defaults to false = set to true to exclude the client files rapid-build sends to the dist client directory
# exclude.default.server.files                      = (boolean) defaults to false = set to true to exclude the server files rapid-build sends to the dist server directory
# exclude.from.cacheBust                            = (array of strings) = file paths: exclude files from the cache bust
# exclude.from.minFile[scripts|styles]              = (array of strings) = file paths: exclude script or style files from automatically being generated in the scripts.min.js or styles.min.css file
# exclude.from.spaFile[scripts|styles]              = (array of strings) = file paths: exclude script or style files from automatically being generated in the spa.html file
# exclude.from.dist[client|server]                  = (array of strings) = file paths: exclude client or server files from the dist folder 
# test.client.browsers                              = (array of browser names) = phantomjs will run by default, optional browser names are ['chrome', 'firefox', 'ie', 'safari'] 
# server.node_modules                               = (array of module names) = node_modules you would like to copy to the server dist, example: ['q']
# httpProxy                                         = (array of objects) = object format: { context: array or string, options: object } for details see: https://git.io/vVyA0
# browser.open                                      = (boolean) defaults to true = open the browser once the build completes, applies to builds: default, dev and prod:server
# browser.reload                                    = (boolean) defaults to true = reloads the browser once you save your src file, only applies to dev builds
# extra.copy[client|server]                         = (array of strings) = file paths: additional files to copy to dist/client and or dist/server that the build didn't copy
# extra.compile.client[coffee|es6|less|sass]        = (array of strings) = file paths: additional files to compile to dist/client that the build didn't compile
# extra.compile.server[less|sass]                   = (array of strings) = file paths: additional files to compile to dist/server that the build didn't compile
# extra.minify.client[css|js]                       = (array of strings) = file paths: additional files to minify in dist/client that the build didn't minify (by default, the build does not minify files in libs or bower_components)
# security.client.clickjacking                      = (boolean) defaults to true = includes a clickjacking defense script in the default spa.html (set to false to disable)
# =====================================================================================================================================================================================================================================
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
		* sass -> css - (client)

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

#### Test Build:
1. run common tasks (see above)
2. copy client test scripts to dist/client/
3. run client tests in [PhantomJS](http://phantomjs.org/)
4. copy server test scripts to dist/server/
5. run server tests using [jasmine](http://jasmine.github.io/)

## Develop Rapidly!
![Shake and Bake!](https://raw.githubusercontent.com/jyounce/rapid-build/master/docs/src/client/images/shake-and-bake.jpg "Shake n' Bake!")

## Known Issues
These are either being worked on or on the todo list.
* doesn't support sass "import multiple files in one @import"
```scss
// note: it will compile but the dist will end up with duplicate css
// example:
@import "rounded-corners", "text-shadow";
```












