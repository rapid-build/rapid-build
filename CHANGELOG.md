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



