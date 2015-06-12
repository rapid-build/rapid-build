# rapid-build

**Under Development (not for use yet)**

## Installation
```bash
$ npm install rapid-build
```

## Information
rapid-build depends on [npm](http://npmjs.org/) and [Node.js](http://nodejs.org/) version >= 0.10.0

## More documentation coming real soon!
This will get you started:

```javascript
var config = {} // optional config
var rapid = require('rapid-build')(config) // init to pass in config options

// rapid returns a promise and has 1 optional param 'dev' or 'prod'
rapid().then(function() {
	console.log('whatever you want')
})
```
OR

```javascript
/**
 * if you are using gulp
 * in your gulpfile.js (there are 3 available tasks)
 * first require rapid-build and provide it gulp
 */
var gulp = require('gulp')
var config = {} // optional config
require('rapid-build')(gulp, config)

// as a gulp task dependency
gulp.task('default', ['rapid-build'])

// or from the terminal type one of the 3:
gulp rapid-build
gulp rapid-build:dev
gulp rapid-build:prod
```

##### Config Documentation - (better documentation coming soon)
```coffeescript
# CONFIG API (optional): config is an object
# dist.dir                                     = (string)  defaults to 'dist'
# dist.client.dir                              = (string)  defaults to 'client'
# dist.client[images|scripts|styles|views].dir = (string)  defaults to property name
# dist.client.bower.dir                        = (string)  defaults to 'bower_components'
# dist.client.libs.dir                         = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# dist.client.spa.file                         = (string)  defaults to 'spa.html'
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
# ===================================================================================================================================================================
```

##### CHANGELOG
Releases are documented here [changelog](https://github.com/jyounce/rapid-build/blob/master/CHANGELOG.md).

### Develop Rapidly!
![Shake and Bake!](docs/shake-and-bake.jpg)


