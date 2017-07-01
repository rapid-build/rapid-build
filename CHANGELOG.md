# [2.0.0](https://github.com/jyounce/rapid-build/compare/v1.1.1...v2.0.0) (2017-07-01)


### Features

* **bump:** dep typescript to v2.4.1 from v2.2.1 ([5c0c9c1](https://github.com/jyounce/rapid-build/commit/5c0c9c1))
* typescript features: [v2.3](https://git.io/vQWhG 'typescript v2.3 features') and [v2.4](https://git.io/vQWh4 'typescript v2.4 features')

### Breaking Changes
Only applies to people using typescript.  
Find breaking changes here:
* [v2.3](https://git.io/vQWhe 'typescript v2.3 breaking changes')
* [v2.4](https://git.io/vQWh0 'typescript v2.4 breaking changes')



## [1.1.1](https://github.com/jyounce/rapid-build/compare/v1.1.0...v1.1.1) (2017-06-21)


### Bug Fixes

* **npm5:** provide npm5 support ([6b489fa](https://github.com/jyounce/rapid-build/commit/6b489fa))
* **quick start:** fix the client app for the quick start's prod:server build, it was crashing the browser ([780ae48](https://github.com/jyounce/rapid-build/commit/780ae48))



# [1.1.0](https://github.com/jyounce/rapid-build/compare/v1.0.0...v1.1.0) (2017-04-20)


### Features

* **build option:** add build option spa[scripts|styles].attrs for ability to add or modify attrs on link and script tags in spa.html ([a857801](https://github.com/jyounce/rapid-build/commit/a857801))



# [1.0.0](https://github.com/jyounce/rapid-build/compare/v0.72.0...v1.0.0) (2017-02-25)


After two years of development and 115 releases, rapid-build has finally reached the 1.0.0 milestone!  
Enjoy and always, *Develop Rapidly!*


### Minor Features

* **bump deps:** includes typescript v2.2.1 ([37d97e8](https://github.com/jyounce/rapid-build/commit/37d97e8))



# [0.72.0](https://github.com/jyounce/rapid-build/compare/v0.71.0...v0.72.0) (2017-02-09)


### Features

* **build option dist.pack:** disabled by default, enable to pack/create a zip, tar or tgz file from the dist directory once the build completes ([729ef3d](https://github.com/jyounce/rapid-build/commit/729ef3d))


### Breaking Changes

* Bumped dependency browserify to [v14.0.0](https://git.io/vDgrS) which drops support for IE8-10.
  This only effects people who are using typescript on the client side and need to support IE8-10.
  ([ada6fbe](https://github.com/jyounce/rapid-build/commit/ada6fbe))



# [0.71.0](https://github.com/jyounce/rapid-build/compare/v0.70.0...v0.71.0) (2017-01-19)


### Features

* **bower.json location:** move bower.json from project root to src/client/ root ([5b20a56](https://github.com/jyounce/rapid-build/commit/5b20a56))


### Breaking Changes

* This is completely an architectural design decision.
  Seems more natural to place **bower.json** inside of **src/client/ root** and not the project's root.
  This **only applies to people** using rapid-build to install client bower_components.

To migrate, move bower.json from project root to src/client/ root.

**Before:**  
bower.json

**Now:**  
src/client/bower.json



# [0.70.0](https://github.com/jyounce/rapid-build/compare/v0.69.5...v0.70.0) (2017-01-13)


### Features

* **npm 3+ support:** get the build working in npm 3+


### Breaking Changes

* To provide npm 3+ support, build option **server.node_modules** has been **removed** and replaced with the standard way of installing node_modules via creating a src/server/package.json

To migrate the code follow the example below:

**Before:**  
For the build to move server node_modules to dist/server/
you had to install them in your project's root then
add something like the following in rapid-build.json:
```json
{
  "server": {
    "node_modules": ["cors"]
  }
}
```

**Now:**  
Do it the natural way by creating a **package.json**
in the root of **src/server/** then install your node_modules
and the build will copy your src/server/node_modules/
to dist/server/. Example of src/server/package.json:
```json
{
  "name": "my-server",
  "version": "1.0.0",
  "dependencies": {
    "cors": "^2.8.1"
  }
}
```



## [0.69.5](https://github.com/jyounce/rapid-build/compare/v0.69.4...v0.69.5) (2016-12-22)


### Bug Fixes

* **windows:** from not opening google chrome browser on dev build, now defaults to opening default browser ([e3496ea](https://github.com/jyounce/rapid-build/commit/e3496ea))



## [0.69.4](https://github.com/jyounce/rapid-build/compare/v0.69.3...v0.69.4) (2016-12-06)


### Bug Fixes

* **windows watch:** fix script file types from not being moved to dist on the dev build's file watch ([829ee63](https://github.com/jyounce/rapid-build/commit/829ee63))



## [0.69.3](https://github.com/jyounce/rapid-build/compare/v0.69.2...v0.69.3) (2016-11-11)


### Bug Fixes

* **server:** build option httpProxy, fix http verbs like put and post from not working when using httpProxy ([d06e4bc](https://github.com/jyounce/rapid-build/commit/d06e4bc))



## [0.69.2](https://github.com/jyounce/rapid-build/compare/v0.69.1...v0.69.2) (2016-10-18)


### Minor Features

* **bump deps:** includes typescript v2.0.3 ([e218c11](https://github.com/jyounce/rapid-build/commit/e218c11))



## [0.69.1](https://github.com/jyounce/rapid-build/compare/v0.69.0...v0.69.1) (2016-09-14)


### Bug Fixes

* **typescript:** fix the build from breaking when typescript server has no tsconfig.json ([e278de0](https://github.com/jyounce/rapid-build/commit/e278de0))



# [0.69.0](https://github.com/jyounce/rapid-build/compare/v0.68.1...v0.69.0) (2016-09-12)


### Features

* **typescript 2:** use typescript 2.0.2 for the builds ([6fad123](https://github.com/jyounce/rapid-build/commit/6fad123))

### Performance Improvements

* **typescript:** improve watch for typescript server ([7730ad7](https://github.com/jyounce/rapid-build/commit/7730ad7))



## [0.68.1](https://github.com/jyounce/rapid-build/compare/v0.68.0...v0.68.1) (2016-08-31)


### Bug Fixes

* **server:** typescript watch ([3a6791d](https://github.com/jyounce/rapid-build/commit/3a6791d))



# [0.68.0](https://github.com/jyounce/rapid-build/compare/v0.67.3...v0.68.0) (2016-08-30)


### Bug Fixes

* **css watch:** fix watch for lazy loaded css files, don't try to inject css changes, just do a page refresh ([f5f20f0](https://github.com/jyounce/rapid-build/commit/f5f20f0))

### Features

* **cli option:** add cli option --cache-list to display the build's internal cache ([164ddc4](https://github.com/jyounce/rapid-build/commit/164ddc4))



## [0.67.3](https://github.com/jyounce/rapid-build/compare/v0.67.2...v0.67.3) (2016-08-17)


### Bug Fixes

* **templateCache watch:** fix dev build template cache watch ([c30e38f](https://github.com/jyounce/rapid-build/commit/c30e38f))



## [0.67.2](https://github.com/jyounce/rapid-build/compare/v0.67.1...v0.67.2) (2016-08-17)


### Bug Fixes

* **reload:** windows fix for browser reload when creating a typescript bundle ([563a32b](https://github.com/jyounce/rapid-build/commit/563a32b))
* **typescript prod build:** windows fix for client typescript prod build ([e7536a4](https://github.com/jyounce/rapid-build/commit/e7536a4))



## [0.67.1](https://github.com/jyounce/rapid-build/compare/v0.67.0...v0.67.1) (2016-08-10)


### Minor Features

* **bump deps:** babel-preset-es2015, browser-sync, event-stream, gulp-watch, karma, phantomjs-prebuilt and postcss ([8e551c6](https://github.com/jyounce/rapid-build/commit/8e551c6))



# [0.67.0](https://github.com/jyounce/rapid-build/compare/v0.66.0...v0.67.0) (2016-08-08)


### Features

* **typescript:** add typescript support, must be enabled via build option compile.typescript\[client|server\].enable ([1a94a60](https://github.com/jyounce/rapid-build/commit/1a94a60))



# [0.66.0](https://github.com/jyounce/rapid-build/compare/v0.65.0...v0.66.0) (2016-08-02)


### Bug Fixes

* **internal:** suffix a hash to internally generated package directory names to avoid naming collisions ([f31d0bf](https://github.com/jyounce/rapid-build/commit/f31d0bf))

### Features

* **cli option:** add cli option --cache-clean to clean the build's internal application(s) cache ([96ed51e](https://github.com/jyounce/rapid-build/commit/96ed51e))



# [0.65.0](https://github.com/jyounce/rapid-build/compare/v0.64.0...v0.65.0) (2016-07-19)


### Features

* **build option:** add build option dist.paths.absolute (defaults to true) set to false to create relative urls, see build options doc for more info ([f0961b4](https://github.com/jyounce/rapid-build/commit/f0961b4))
* **messaging:** improve console messaging when running builds ([5b7f092](https://github.com/jyounce/rapid-build/commit/5b7f092))



# [0.64.0](https://github.com/jyounce/rapid-build/compare/v0.63.0...v0.64.0) (2016-07-01)


### Features

* **quick start:** add ability to create a quick application structure fast via running rapid-build --quick-start ([986e476](https://github.com/jyounce/rapid-build/commit/986e476))



# [0.63.0](https://github.com/jyounce/rapid-build/compare/v0.62.0...v0.63.0) (2016-07-01)


### Features

* **build options:** add ability to skip build option(s) when running a build via --skip-options optX ([f0804d2](https://github.com/jyounce/rapid-build/commit/f0804d2))



# [0.62.0](https://github.com/jyounce/rapid-build/compare/v0.61.2...v0.62.0) (2016-06-22)


### Features

* **rapid-build cli:** create the rapid-build cli, build.js is no longer required instead run rapid-build from terminal ([16322a7](https://github.com/jyounce/rapid-build/commit/16322a7))



## [0.61.2](https://github.com/jyounce/rapid-build/compare/v0.61.1...v0.61.2) (2016-06-21)


### Minor Features
* **bump deps:**
	* spring cleaning, updated many dependency packages notable updates include:
		* express from 4.13.4 to 4.14.0 ([868049f](https://github.com/jyounce/rapid-build/commit/868049f))
		* babel-preset-es2015 from 6.6.0 to 6.9.0 ([c8f4919](https://github.com/jyounce/rapid-build/commit/c8f4919))
		* gulp-less from 3.0.5 to 3.1.0 and gulp-sass from 2.2.0 to 2.3.2 ([ee0dc6b](https://github.com/jyounce/rapid-build/commit/ee0dc6b))



## [0.61.1](https://github.com/jyounce/rapid-build/compare/v0.61.0...v0.61.1) (2016-06-21)


### Bug Fixes

* **dep:** bump gulp-angular-templatecache to v1.9.1, it fixes it's gulp-header dependency ([39f7d5a](https://github.com/jyounce/rapid-build/commit/39f7d5a))
* **server:** set express's static directory after running user's routes.js so middleware can be applied to static files ([1de65b1](https://github.com/jyounce/rapid-build/commit/1de65b1))



# [0.61.0](https://github.com/jyounce/rapid-build/compare/v0.60.1...v0.61.0) (2016-06-16)


### Features

* **option:** exclude.from.spaFile.angular.files, set to true to exclude the angular files from spa.html that come with rapid-build ([fadbb16](https://github.com/jyounce/rapid-build/commit/fadbb16))



## [0.60.1](https://github.com/jyounce/rapid-build/compare/v0.60.0...v0.60.1) (2016-06-11)


### Bug Fixes

* **spa.html:** make sure auto inject places ng-app on an uncommented html tag ([8bc70fb](https://github.com/jyounce/rapid-build/commit/8bc70fb))



# [0.60.0](https://github.com/jyounce/rapid-build/compare/v0.59.1...v0.60.0) (2016-06-08)


### Features

* **option:** add option angular.bootstrap to bootstrap angular instead of using ng-app in spa.html, defaults to false ([fd43076](https://github.com/jyounce/rapid-build/commit/fd43076))



## [0.59.1](https://github.com/jyounce/rapid-build/compare/v0.59.0...v0.59.1) (2016-06-07)


### Bug Fixes

* **spa watch:** fix the watch on the custom spa.html ([3df516a](https://github.com/jyounce/rapid-build/commit/3df516a))



# [0.59.0](https://github.com/jyounce/rapid-build/compare/v0.58.2...v0.59.0) (2016-06-03)


### Features

* **spa auto inject:** the build will automatically inject scripts and styles into your spa.html ([2b5a556](https://github.com/jyounce/rapid-build/commit/2b5a556))
* **documentation site:** [http://rapid-build.io/](http://rapid-build.io/)

### Breaking Changes

* spa auto inject: The build will now automatically inject scripts and styles into your spa.html unless you are using build placeholders in your spa.html. You can disable this feature by providing option spa.autoInject false.



## [0.58.2](https://github.com/jyounce/rapid-build/compare/v0.58.1...v0.58.2) (2016-05-27)


### Bug Fixes

* **test builds:** fix non dev test builds, ensure the server stops and the build completes ([9f8059d](https://github.com/jyounce/rapid-build/commit/9f8059d))



## [0.58.1](https://github.com/jyounce/rapid-build/compare/v0.58.0...v0.58.1) (2016-05-17)


### Bug Fixes

* **bower:** do not download the build's default bower files when option exclude.default.client.files is true ([d73f353](https://github.com/jyounce/rapid-build/commit/d73f353))



# [0.58.0](https://github.com/jyounce/rapid-build/compare/v0.57.0...v0.58.0) (2016-05-04)


### Features

* **option:** add ability to disable clickjacking defense script in default spa.html via option security.client.clickjacking ([56b92dc](https://github.com/jyounce/rapid-build/commit/56b92dc))



# [0.57.0](https://github.com/jyounce/rapid-build/compare/v0.56.1...v0.57.0) (2016-04-30)


### Features

* **option:** add build option extra.minify.client\[css|js\] ([4124999](https://github.com/jyounce/rapid-build/commit/4124999))



## [0.56.1](https://github.com/jyounce/rapid-build/compare/v0.56.0...v0.56.1) (2016-04-29)


### Minor Features

* **bump dep:** fs-extra ([d0764f8](https://github.com/jyounce/rapid-build/commit/74195d0))



# [0.56.0](https://github.com/jyounce/rapid-build/compare/v0.55.0...v0.56.0) (2016-04-27)


### Features

* **server:** expose dist start and stop server scripts, can be called with package.json scripts ([c1ed95f](https://github.com/jyounce/rapid-build/commit/c1ed95f))
	* start: dist/server/rapid-build/start-server
	* stop: dist/server/rapid-build/stop-server


### Breaking Changes

The start server file changed.

**Before:**  
dist/server/rapid-build/init-server.js

**Now:**  
dist/server/rapid-build/start-server.js



# [0.55.0](https://github.com/jyounce/rapid-build/compare/v0.54.0...v0.55.0) (2016-04-09)


### Performance Improvements

* **express:** speed up express by setting process.env.NODE_ENV to production on prod builds ([2a6bae0](https://github.com/jyounce/rapid-build/commit/2a6bae0))



# [0.54.0](https://github.com/jyounce/rapid-build/compare/v0.53.2...v0.54.0) (2016-04-09)


### Bug Fixes

* **bower:** get installed bower pkg version from pkg's .bower.json ([487de5f](https://github.com/jyounce/rapid-build/commit/487de5f))

### Features

* **option:** add build option minify.html.options for full control over how the html gets minified ([f0ab5a2](https://github.com/jyounce/rapid-build/commit/f0ab5a2))



## [0.53.2](https://github.com/jyounce/rapid-build/compare/v0.53.1...v0.53.2) (2016-04-09)


### Minor Features

* **bump deps:** bower and gulp-template ([d0764f8](https://github.com/jyounce/rapid-build/commit/d0764f8))



## [0.53.1](https://github.com/jyounce/rapid-build/compare/v0.53.0...v0.53.1) (2016-04-01)


### Bug Fixes

* **travis ci:** add skip_cleanup on deploy ([1bc3688](https://github.com/jyounce/rapid-build/commit/1bc3688))



# [0.53.0](https://github.com/jyounce/rapid-build/compare/0.52.1...v0.53.0) (2016-04-01)


### Performance Improvements

* **lib:** boost performance by minifying the published javascript files in the lib directory ([9b2a6a0](https://github.com/jyounce/rapid-build/commit/9b2a6a0))



## [0.52.1](https://github.com/jyounce/rapid-build/compare/0.52.0...v0.52.1) (2016-03-30)


### Bug Fixes

* **lib:** do not register coffee on init script in lib ([444043a](https://github.com/jyounce/rapid-build/commit/444043a))



# [0.52.0](https://github.com/jyounce/rapid-build/compare/v0.51.2...v0.52.0) (2016-03-30)


### Performance Improvements

* **lib:** boost performance by precompiling the lib folder's coffee files into js files, package now ships with no coffee files ([6b356d9](https://github.com/jyounce/rapid-build/commit/6b356d9))



## [0.51.2](https://github.com/jyounce/rapid-build/compare/v0.51.1...v0.51.2) (2016-03-29)


### Minor Features

* **bump deps:** babel-preset-es2015, browser-sync, fs-extra, glob-stream, gulp-uglify, http-proxy-middleware, karma, karma-jasmine-matchers, karma-chrome-launcher, phantomjs-prebuilt and postcss ([1d6de7b](https://github.com/jyounce/rapid-build/commit/1d6de7b))



## [0.51.1](https://github.com/jyounce/rapid-build/compare/v0.51.0...v0.51.1) (2016-02-17)


### Bug Fixes

* **server tests:** to recognize jasmine-expect matchers when installed globally ([840afbb](https://github.com/jyounce/rapid-build/commit/840afbb))



# [0.51.0](https://github.com/jyounce/rapid-build/compare/v0.50.0...v0.51.0) (2016-02-17)


### Features

* **windows:** add support for build and project being on different drives ([ac69d31](https://github.com/jyounce/rapid-build/commit/ac69d31))



# [0.50.0](https://github.com/jyounce/rapid-build/compare/v0.49.0...v0.50.0) (2016-02-10)


### Features

* **installation:** add global install support, eliminating the need to install the build multiple times ([4fa26ef](https://github.com/jyounce/rapid-build/commit/4fa26ef))



# [0.49.0](https://github.com/jyounce/rapid-build/compare/v0.48.0...v0.49.0) (2016-02-02)


### Features
* **bump deps:**
	* gulp-babel and karma-jasmine ([9c96e3f](https://github.com/jyounce/rapid-build/commit/9c96e3f))
	* replace gulp-minify-html with gulp-htmlmin for html minification ([2002c42](https://github.com/jyounce/rapid-build/commit/2002c42))



# [0.48.0](https://github.com/jyounce/rapid-build/compare/v0.47.0...v0.48.0) (2016-01-29)


### Features
* **bump deps:**
	* replace gulp-minify-css with gulp-cssnano for css minification ([e91e55c](https://github.com/jyounce/rapid-build/commit/e91e55c))
	* bower, browser-sync, express, fs-extra, http-proxy-middleware, jasmine-terminal-reporter, karma, karma-phantomjs-launcher, phantomjs-prebuilt and postcss ([1101b60](https://github.com/jyounce/rapid-build/commit/1101b60))



# [0.47.0](https://github.com/jyounce/rapid-build/compare/v0.46.0...v0.47.0) (2015-12-29)


### Features

* **bump deps:**
	* conventional-changelog, gulp-nodemon, gulp-sequence, karma and karma-phantomjs-launcher ([ceb1692](https://github.com/jyounce/rapid-build/commit/ceb1692))
	* glob-stream ([b3c911b](https://github.com/jyounce/rapid-build/commit/b3c911b))
	* body-parser, browser-sync, fs-extra and postcss ([cf00060](https://github.com/jyounce/rapid-build/commit/cf00060))
	* bower ([c40b8bf](https://github.com/jyounce/rapid-build/commit/c40b8bf))
	* gulp-sass ([bbc3cfb](https://github.com/jyounce/rapid-build/commit/bbc3cfb))



# [0.46.0](https://github.com/jyounce/rapid-build/compare/v0.45.0...v0.46.0) (2015-12-08)


### Features

* **bump deps:**
	* bower and del ([ddf421a](https://github.com/jyounce/rapid-build/commit/ddf421a))
	* babel-preset-es2015, jasmine and jasmine-core ([2d70dd0](https://github.com/jyounce/rapid-build/commit/2d70dd0))
	* gulp-babel, gulp-minify-css, karma-chrome-launcher and phantomjs ([e02c336](https://github.com/jyounce/rapid-build/commit/e02c336))
	* gulp-template ([85312b0](https://github.com/jyounce/rapid-build/commit/85312b0))



# [0.45.0](https://github.com/jyounce/rapid-build/compare/v0.44.0...v0.45.0) (2015-11-14)


### Features

* **build completion:** resolve the build's config when it's promise is fulfilled ([865e245](https://github.com/jyounce/rapid-build/commit/865e245))
* **option:** add build option exclude.default.client.files which is a boolean and defaults to false ([8ec2049](https://github.com/jyounce/rapid-build/commit/8ec2049))



# [0.44.0](https://github.com/jyounce/rapid-build/compare/v0.43.1...v0.44.0) (2015-11-10)


### Bug Fixes

* **compiling es6:** add babel plugin, babel-preset-es2015 ([a0ca9b0](https://github.com/jyounce/rapid-build/commit/a0ca9b0))

### Features

* **option:** add build option exclude.default.server.files which is a boolean and defaults to false ([a7ed1ed](https://github.com/jyounce/rapid-build/commit/a7ed1ed))



## [0.43.1](https://github.com/jyounce/rapid-build/compare/v0.43.0...v0.43.1) (2015-11-08)


### Bug Fixes

* **windows:** ensure correct file paths in spa.html ([8fc5868](https://github.com/jyounce/rapid-build/commit/8fc5868))



# [0.43.0](https://github.com/jyounce/rapid-build/compare/v0.42.3...v0.43.0) (2015-11-07)


### Bug Fixes

* **minifying client json:** do not use uglify-js to minify client json files, it has issues with quoted json keys ([2959573](https://github.com/jyounce/rapid-build/commit/2959573))

### Features

* **babel:** use npm package babel-plugin-transform-strict-mode ([206ade4](https://github.com/jyounce/rapid-build/commit/206ade4))
* **option:** add build option browser.reload which defaults to true and only applies to dev builds ([354004d](https://github.com/jyounce/rapid-build/commit/354004d))



## [0.42.3](https://github.com/jyounce/rapid-build/compare/v0.42.2...v0.42.3) (2015-11-01)


### Bug Fixes

* **client file paths:** output absolute file paths in spa.html instead of relative ([ed337a3](https://github.com/jyounce/rapid-build/commit/ed337a3))



## [0.42.2](https://github.com/jyounce/rapid-build/compare/v0.42.1...v0.42.2) (2015-10-15)


### Bug Fixes

* **server:** fix parsing application/json post and put requests ([ba2aa71](https://github.com/jyounce/rapid-build/commit/ba2aa71))



## [0.42.1](https://github.com/jyounce/rapid-build/compare/v0.42.0...v0.42.1) (2015-10-09)


### Bug Fixes

* **option:** fix build option httpProxy by removing lodash dependency ([7439f93](https://github.com/jyounce/rapid-build/commit/7439f93))
* **server:** allow application to define express's home route '/' if necessary ([7a1e472](https://github.com/jyounce/rapid-build/commit/7a1e472))
* **windows:** fix the watch for less and sass ([4689c64](https://github.com/jyounce/rapid-build/commit/4689c64))



# [0.42.0](https://github.com/jyounce/rapid-build/compare/v0.41.0...v0.42.0) (2015-10-07)


### Performance Improvements

* **tasks:** lazy load build tasks ([18c9e57](https://github.com/jyounce/rapid-build/commit/18c9e57))



# [0.41.0](https://github.com/jyounce/rapid-build/compare/v0.40.1...v0.41.0) (2015-10-05)


### Features

* **api task:** create and expose api task dev:test:server ([702ae85](https://github.com/jyounce/rapid-build/commit/702ae85))
* **api tasks:** create and expose api tasks dev:test and dev:test:client ([b84bea0](https://github.com/jyounce/rapid-build/commit/b84bea0))



## [0.40.1](https://github.com/jyounce/rapid-build/compare/v0.40.0...v0.40.1) (2015-09-30)


### Bug Fixes

* **api:** change task test:prod to prod:test ([8d19e4f](https://github.com/jyounce/rapid-build/commit/8d19e4f))
* **test server task:** stop the server when the test has ran ([9a2f9e9](https://github.com/jyounce/rapid-build/commit/9a2f9e9))


### Breaking Changes

* The application server routes file arguments have changed because it was limited to only app and opts. Now this file accepts one server argument that is an object containing app, express, middleware, paths and server.

**Before:**
```javascript
module.exports = (app, opts) => {
  app.get('/api/superheroes', (req, res) => {})
  ...
}
```

**Now:**
```javascript
module.exports = (server) => {
  var app = server.app

  app.get('/api/superheroes', (req, res) => {})
  ...
}
```



# [0.40.0](https://github.com/jyounce/rapid-build/compare/v0.39.0...v0.40.0) (2015-09-27)


### Features

* **api tasks:** create and expose api tasks test:client and test:server, change existing test task to run both ([18db4de](https://github.com/jyounce/rapid-build/commit/18db4de))

### Breaking Changes
The api option test.browsers has changed to test.client.browsers because the build now supports testing client and server side code.

**Before:**  
options.test.browsers

**Now:**  
options.test.client.browsers



# [0.39.0](https://github.com/jyounce/rapid-build/compare/v0.38.0...v0.39.0) (2015-09-25)


### Features

* **option:** add build option minify\[css|js\].fileName ([d020567](https://github.com/jyounce/rapid-build/commit/d020567))



# [0.38.0](https://github.com/jyounce/rapid-build/compare/v0.37.0...v0.38.0) (2015-09-25)


### Features

* **option:** add build option exclude.spa, defaults to false ([0f0df60](https://github.com/jyounce/rapid-build/commit/0f0df60))



# [0.37.0](https://github.com/jyounce/rapid-build/compare/v0.36.0...v0.37.0) (2015-09-24)


### Features

* **option:** add build option browser.open, defaults to true ([5885e17](https://github.com/jyounce/rapid-build/commit/5885e17))



# [0.36.0](https://github.com/jyounce/rapid-build/compare/v0.35.0...v0.36.0) (2015-09-24)


### Bug Fixes

* **server:** copy server js src files to the server ([a4108d9](https://github.com/jyounce/rapid-build/commit/a4108d9))

### Features

* **option:** add build option build\[client|server\] both default to true ([8af0923](https://github.com/jyounce/rapid-build/commit/8af0923))



# [0.35.0](https://github.com/jyounce/rapid-build/compare/v0.34.0...v0.35.0) (2015-09-22)


### Bug Fixes

* **css imports:** external urls ([4f1b82f](https://github.com/jyounce/rapid-build/commit/4f1b82f))

### Features

* **sass:** let's get sassy! add support for sass, also fix some less import bugs ([0fe3b96](https://github.com/jyounce/rapid-build/commit/0fe3b96))



# [0.34.0](https://github.com/jyounce/rapid-build/compare/v0.33.1...v0.34.0) (2015-09-20)


### Features

* **option:** add build option extra.compile ([9cdfa16](https://github.com/jyounce/rapid-build/commit/9cdfa16))



## [0.33.1](https://github.com/jyounce/rapid-build/compare/v0.33.0...v0.33.1) (2015-09-20)


### Bug Fixes

* **css imports:** add support for css imports ([032f470](https://github.com/jyounce/rapid-build/commit/032f470))



# [0.33.0](https://github.com/jyounce/rapid-build/compare/v0.32.0...v0.33.0) (2015-09-09)


### Bug Fixes

* **angular:** prevent browser from throwing an error if angular isn't defined in app.js ([464f552](https://github.com/jyounce/rapid-build/commit/464f552))

### Features

* **option:** add build option exclude.angular.modules ([a457e8e](https://github.com/jyounce/rapid-build/commit/a457e8e))



# [0.32.0](https://github.com/jyounce/rapid-build/compare/v0.31.6...v0.32.0) (2015-09-01)


### Features

* **option:** add build option extra.copy\[client|server\] ([757f328](https://github.com/jyounce/rapid-build/commit/757f328))



## [0.31.6](https://github.com/jyounce/rapid-build/compare/v0.31.5...v0.31.6) (2015-08-28)


### Bug Fixes

* **prepublish:** install node_modules that prepublish uses on npm prepublish ([ffa81f2](https://github.com/jyounce/rapid-build/commit/ffa81f2))

### Performance Improvements

* **server:** start the server via require instead of using node's spawn function ([efc41ce](https://github.com/jyounce/rapid-build/commit/efc41ce))



## [0.31.5](https://github.com/jyounce/rapid-build/compare/v0.31.4...v0.31.5) (2015-08-26)


### Bug Fixes

* **npmignore:** add npm prepublish script to remove bower_components directory ([03da374](https://github.com/jyounce/rapid-build/commit/03da374))
* **npmignore:** exclude files that aren't needed ([f0907c1](https://github.com/jyounce/rapid-build/commit/f0907c1))



## [0.31.4](https://github.com/jyounce/rapid-build/compare/v0.31.3...v0.31.4) (2015-08-21)


### Bug Fixes

* **templateCache:** fix the build from crashing when running templateCache with no views ([e588220](https://github.com/jyounce/rapid-build/commit/e588220))



## [0.31.3](https://github.com/jyounce/rapid-build/compare/v0.31.2...v0.31.3) (2015-08-19)


### Bug Fixes

* **readme:** shake n bake! pic ([62a9db6](https://github.com/jyounce/rapid-build/commit/62a9db6))



## [0.31.2](https://github.com/jyounce/rapid-build/compare/v0.31.1...v0.31.2) (2015-08-19)


### Performance Improvements

* **tasks:** change copy and compile tasks to run async instead of sync ([b1b73d9](https://github.com/jyounce/rapid-build/commit/b1b73d9))



## [0.31.1](https://github.com/jyounce/rapid-build/compare/v0.31.0...v0.31.1) (2015-08-19)


### Bug Fixes

* **watch:** do not watch src files that are excluded from dist ([d4ae8e1](https://github.com/jyounce/rapid-build/commit/d4ae8e1))



# [0.31.0](https://github.com/jyounce/rapid-build/compare/v0.30.0...v0.31.0) (2015-08-18)


### Features

* **option:** add option exclude.from.dist\[client|server\] ([1413029](https://github.com/jyounce/rapid-build/commit/1413029))



# [0.30.0](https://github.com/jyounce/rapid-build/compare/v0.29.0...v0.30.0) (2015-08-15)


### Features

* **express:** use middleware body-parser to parse application/json ([2e635da](https://github.com/jyounce/rapid-build/commit/2e635da))



# [0.29.0](https://github.com/jyounce/rapid-build/compare/v0.28.0...v0.29.0) (2015-08-11)


### Features

* **option:** add httpProxy option, useful when you want to test external api(s) ([b30b2ae](https://github.com/jyounce/rapid-build/commit/b30b2ae))



# [0.28.0](https://github.com/jyounce/rapid-build/compare/v0.27.0...v0.28.0) (2015-08-11)


### Features

* **option:** add ports.reloadUI option to set browsersync's user-interface server port ([1290b4e](https://github.com/jyounce/rapid-build/commit/1290b4e))
* **servers:** find an open server port and use it if a port is already in use ([5d1b34d](https://github.com/jyounce/rapid-build/commit/5d1b34d))



# [0.27.0](https://github.com/jyounce/rapid-build/compare/v0.26.2...v0.27.0) (2015-08-11)


### Features

* **option:** add angular.ngFormify option ([876df59](https://github.com/jyounce/rapid-build/commit/876df59))



## [0.26.2](https://github.com/jyounce/rapid-build/compare/v0.26.1...v0.26.2) (2015-08-01)


### Bug Fixes

* **server:** add ability for server file to work with other servers via process.env.PORT ([5283bea](https://github.com/jyounce/rapid-build/commit/5283bea))



## [0.26.1](https://github.com/jyounce/rapid-build/compare/0.26.0...v0.26.1) (2015-07-28)


### Bug Fixes

* **cache busting:** by changing libs and bower_components css urls to absolute for the prod build ([dcd845a](https://github.com/jyounce/rapid-build/commit/dcd845a))



# [0.26.0](https://github.com/jyounce/rapid-build/compare/v0.25.0...0.26.0) (2015-07-28)


### Features

* **server:** add quick server startup with spawn server and use nodemon for dev build ([cd289bf](https://github.com/jyounce/rapid-build/commit/cd289bf))



# [0.25.0](https://github.com/jyounce/rapid-build/compare/v0.24.0...v0.25.0) (2015-07-24)


### Features

* **option:** add angular.templateCache.urlPrefix option ([db7ca9b](https://github.com/jyounce/rapid-build/commit/db7ca9b))



# [0.24.0](https://github.com/jyounce/rapid-build/compare/v0.23.0...v0.24.0) (2015-07-23)


### Features

* **config:** add config.server.node_modules option to copy node_modules to server dist ([a25a3f5](https://github.com/jyounce/rapid-build/commit/a25a3f5))



# [0.23.0](https://github.com/jyounce/rapid-build/compare/v0.22.0...v0.23.0) (2015-07-23)


### Bug Fixes

* **server options:** replace dist.server.file with dist.server.fileName for consistency ([f1bb3f9](https://github.com/jyounce/rapid-build/commit/f1bb3f9))
* **spa options:** replace spa.src.file and dir with filePath and change spa.dist.file to fileName ([40cfee2](https://github.com/jyounce/rapid-build/commit/40cfee2))
* **spa.html:** ensure only src spa.html get's moved to client dist root ([856395e](https://github.com/jyounce/rapid-build/commit/856395e))

### Features

* **server:** pass options that contain dir info to the server entry script ([aa68acd](https://github.com/jyounce/rapid-build/commit/aa68acd))



# [0.22.0](https://github.com/jyounce/rapid-build/compare/v0.21.0...v0.22.0) (2015-07-18)


### Features

* **add build:** create and expose build rapid-build:test:prod for testing prod builds ([f54d114](https://github.com/jyounce/rapid-build/commit/f54d114))



# [0.21.0](https://github.com/jyounce/rapid-build/compare/v0.20.0...v0.21.0) (2015-07-17)


### Bug Fixes

* **prod build:** do not start the server ([4acd8d3](https://github.com/jyounce/rapid-build/commit/4acd8d3))

### Features

* **build:** create and expose prod build that starts the server via rapid-build:prod:server ([b3d593c](https://github.com/jyounce/rapid-build/commit/b3d593c))



# [0.20.0](https://github.com/jyounce/rapid-build/compare/v0.19.0...v0.20.0) (2015-07-16)


### Bug Fixes

* **testing:** do not run tests if there are no test scripts ([227ec95](https://github.com/jyounce/rapid-build/commit/227ec95))

### Features

* **testing:** add karma-jasmine-matchers for additional test cases ([805e598](https://github.com/jyounce/rapid-build/commit/805e598))
* **testing:** add port option for the karma server ([692e62f](https://github.com/jyounce/rapid-build/commit/692e62f))



# [0.19.0](https://github.com/jyounce/rapid-build/compare/v0.18.1...v0.19.0) (2015-07-16)


### Features

* **api task:** create and expose test task via rapid-build:test ([725b960](https://github.com/jyounce/rapid-build/commit/725b960))
* **testing:** add karm browser launchers for chrome, firefox, ie and safari ([f9dcc90](https://github.com/jyounce/rapid-build/commit/f9dcc90))
* **testing:** add option test.browsers to run tests in additional browsers ([5d6864d](https://github.com/jyounce/rapid-build/commit/5d6864d))



## [0.18.1](https://github.com/jyounce/rapid-build/compare/v0.18.0...v0.18.1) (2015-07-14)


### Bug Fixes

* **cache busting:** prevent prod build crash on windows by running runDelUnstampedPaths last ([89e7aa2](https://github.com/jyounce/rapid-build/commit/89e7aa2))
* **option:** custom spa.html file when no spa.src.dir is supplied ([54eae80](https://github.com/jyounce/rapid-build/commit/54eae80))
* **task:** build spa by temporarily removing delCustomSpaTask() ([3dde07c](https://github.com/jyounce/rapid-build/commit/3dde07c))



# [0.18.0](https://github.com/jyounce/rapid-build/compare/v0.17.1...v0.18.0) (2015-07-13)


### Features

* **option:** add option exclude.from.minFile\[scripts|styles\] while maintaining order option ([60634c9](https://github.com/jyounce/rapid-build/commit/60634c9))



## [0.17.1](https://github.com/jyounce/rapid-build/compare/v0.17.0...v0.17.1) (2015-07-12)


### Bug Fixes

* **minify:** ability for css file split to handle multiple css min files ([d18a02f](https://github.com/jyounce/rapid-build/commit/d18a02f))
* **minify:** ensure css doesn't break the build on really large files ([fdd3cee](https://github.com/jyounce/rapid-build/commit/fdd3cee))



# [0.17.0](https://github.com/jyounce/rapid-build/compare/v0.16.0...v0.17.0) (2015-07-10)


### Bug Fixes

* **option:** remove options angular.exclude.files and spa.exclude, replace with the exclude option ([4904685](https://github.com/jyounce/rapid-build/commit/4904685))
* **options:** change option exclude\[scripts|styles\].from.spaFile to exclude.from.spaFile\[scripts|styles\] ([136c042](https://github.com/jyounce/rapid-build/commit/136c042))
* **windows:** cache busting for prod ([fa45be6](https://github.com/jyounce/rapid-build/commit/fa45be6))

### Features

* **exclude:** add option exclude.from.cacheBust ([03d18e1](https://github.com/jyounce/rapid-build/commit/03d18e1))



# [0.16.0](https://github.com/jyounce/rapid-build/compare/v0.15.0...v0.16.0) (2015-07-02)


### Features

* **option:** add option minify.spa.file ([4b0e612](https://github.com/jyounce/rapid-build/commit/4b0e612))



# [0.15.0](https://github.com/jyounce/rapid-build/compare/v0.14.0...v0.15.0) (2015-07-02)


### Features

* **cache busting:** add cache busting to the prod build for the client ([7f66d19](https://github.com/jyounce/rapid-build/commit/7f66d19))
* **option:** add option to disable cache busting via option.minify.cacheBust ([6d445c7](https://github.com/jyounce/rapid-build/commit/6d445c7))



# [0.14.0](https://github.com/jyounce/rapid-build/compare/v0.13.0...v0.14.0) (2015-06-30)


### Features

* **minify:** add task css-file-split for lte ie9, split styles.min.css into multiple files if selector count > 4,095 ([9a40c94](https://github.com/jyounce/rapid-build/commit/9a40c94))
* **option:** add option minify.css.splitMinFile to disable the splitting of styles.min.css ([686b3fd](https://github.com/jyounce/rapid-build/commit/686b3fd))



# [0.13.0](https://github.com/jyounce/rapid-build/compare/v0.12.0...v0.13.0) (2015-06-30)


### Bug Fixes

* **option:** change option angular.templateCache.dev.enable to angular.templateCache.dev ([dd7a7f8](https://github.com/jyounce/rapid-build/commit/dd7a7f8))
* **option:** change option spa.exclude to spa.placeholders, makes more sense ([395cd37](https://github.com/jyounce/rapid-build/commit/395cd37))

### Features

* **options:** add options spa.exclude.scripts and styles, exclude from spa.html file and min files ([5273bb6](https://github.com/jyounce/rapid-build/commit/5273bb6))



# [0.12.0](https://github.com/jyounce/rapid-build/compare/v0.11.1...v0.12.0) (2015-06-26)


### Features

* **angular:** add option angular.httpBackend to enable angular mocks ([4688281](https://github.com/jyounce/rapid-build/commit/4688281))



## [0.11.1](https://github.com/jyounce/rapid-build/compare/v0.11.0...v0.11.1) (2015-06-24)


### Bug Fixes

* **less:** npm update required, do not send less imports to the dist folder ([d3742e6](https://github.com/jyounce/rapid-build/commit/d3742e6))



# [0.11.0](https://github.com/jyounce/rapid-build/compare/v0.10.0...v0.11.0) (2015-06-24)


### Features

* **options:** add minification options via the minify object ([bc288dc](https://github.com/jyounce/rapid-build/commit/bc288dc))



# [0.10.0](https://github.com/jyounce/rapid-build/compare/v0.9.0...v0.10.0) (2015-06-17)


### Bug Fixes

* **options:** fix options dist.client.dir and dist.server.dir ([99564c2](https://github.com/jyounce/rapid-build/commit/99564c2))
* **prod build:** fix the loading order of scripts and styles ([6aad6b9](https://github.com/jyounce/rapid-build/commit/6aad6b9))

### Features

* **options:** change option spa.exclude value to be an array of strings ([171426f](https://github.com/jyounce/rapid-build/commit/171426f))



# [0.9.0](https://github.com/jyounce/rapid-build/compare/v0.8.0...v0.9.0) (2015-06-17)


### Features

* **options:** add ability to exclude angular files from the build ([7d06c14](https://github.com/jyounce/rapid-build/commit/7d06c14))



# [0.8.0](https://github.com/jyounce/rapid-build/compare/v0.7.0...v0.8.0) (2015-06-14)


### Bug Fixes

* **config:** change config option name spaFile to spa ([0dbd5dc](https://github.com/jyounce/rapid-build/commit/0dbd5dc))

### Features

* **options:** add option to use a custom spa file and not the build system's ([763322c](https://github.com/jyounce/rapid-build/commit/763322c))



# [0.7.0](https://github.com/jyounce/rapid-build/compare/v0.6.0...v0.7.0) (2015-06-11)


### Features

* **plumber:** add the plumber to the lang compilers so the watch doesn't break on an error ([722750d](https://github.com/jyounce/rapid-build/commit/722750d))



# [0.6.0](https://github.com/jyounce/rapid-build/compare/v0.5.0...v0.6.0) (2015-06-11)


### Features

* **libs:** add support for client 3rd party libs and move bower comps to bower_components ([41d671f](https://github.com/jyounce/rapid-build/commit/41d671f))



# [0.5.0](https://github.com/jyounce/rapid-build/compare/v0.4.0...v0.5.0) (2015-06-09)


### Features

* **bower:** add support for bower packages dependencies ([24f761d](https://github.com/jyounce/rapid-build/commit/24f761d))
* **config:** add ability to change angular version via config ([2f6e269](https://github.com/jyounce/rapid-build/commit/2f6e269))



# [0.4.0](https://github.com/jyounce/rapid-build/compare/v0.3.0...v0.4.0) (2015-06-05)


### Features

* **config:** add angular option to change the module name and add additional modules ([aeaa8c1](https://github.com/jyounce/rapid-build/commit/aeaa8c1))



# [0.3.0](https://github.com/jyounce/rapid-build/compare/v0.2.0...v0.3.0) (2015-06-05)


### Features

* **angular:** add template cache options dev.enable and useAbsolutePaths to config ([dc48e5b](https://github.com/jyounce/rapid-build/commit/dc48e5b))
* **bower:** start of app support for bower ([74825ef](https://github.com/jyounce/rapid-build/commit/74825ef))
* **watch:** add support for watching the template cache ([b6237f2](https://github.com/jyounce/rapid-build/commit/b6237f2))



# [0.2.0](https://github.com/jyounce/rapid-build/compare/v0.1.4...v0.2.0) (2015-05-30)


### Features

* **changelog:** add it ([52058a0](https://github.com/jyounce/rapid-build/commit/52058a0))



## [0.1.4](https://github.com/jyounce/rapid-build/compare/v0.1.3...v0.1.4) (2015-05-28)


### Bug Fixes

* **gulp:** make gulp a dep if app is using gulp ([4184bf4](https://github.com/jyounce/rapid-build/commit/4184bf4))



## [0.1.3](https://github.com/jyounce/rapid-build/compare/v0.1.2...v0.1.3) (2015-05-28)


### Bug Fixes

* **gulp:** load gulp from app's node_modules if present ([91cd0ad](https://github.com/jyounce/rapid-build/commit/91cd0ad))



## [0.1.2](https://github.com/jyounce/rapid-build/compare/v0.1.1...v0.1.2) (2015-05-27)


### Bug Fixes

* **windows:** paths in spa html file ([e41d7a7](https://github.com/jyounce/rapid-build/commit/e41d7a7))



## [0.1.1](https://github.com/jyounce/rapid-build/compare/v0.1.0...v0.1.1) (2015-05-27)


### README Update

* **readme:** remove duplicate description ([c9b11f7c](https://github.com/jyounce/rapid-build/commit/c9b11f7c))



# 0.1.0 (2015-05-27)


### Initial Release

* **init:** rapid-build ([31a96692](https://github.com/jyounce/rapid-build/commit/31a96692))



