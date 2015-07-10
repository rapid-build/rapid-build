## 0.17.0 (2015-07-10)


#### Bug Fixes

* **option:** remove options angular.exclude.files and spa.exclude, replace with the exclude option ([4904685d](https://github.com/jyounce/rapid-build/commit/4904685d))
* **options:** change option exclude[scripts|styles].from.spaFile to exclude.from.spaFile\[scripts|styles\] ([136c042a](https://github.com/jyounce/rapid-build/commit/136c042a))
* **windows:** cache busting for prod ([fa45be6f](https://github.com/jyounce/rapid-build/commit/fa45be6f))


#### Features

* **exclude:** add option exclude.from.cacheBust ([03d18e11](https://github.com/jyounce/rapid-build/commit/03d18e11))


## 0.16.0 (2015-07-01)


#### Features

* **option:** add option minify.spa.file ([4b0e6128](https://github.com/jyounce/rapid-build/commit/4b0e6128))


## 0.15.0 (2015-07-01)


#### Features

* **cache busting:** add cache busting to the prod build for the client ([7f66d19d](https://github.com/jyounce/rapid-build/commit/7f66d19d))
* **option:** add option to disable cache busting via option.minify.cacheBust ([6d445c7c](https://github.com/jyounce/rapid-build/commit/6d445c7c))


## 0.14.0 (2015-06-30)


#### Features

* **minify:** add task css-file-split for lte ie9, split styles.min.css into multiple files if selector count > 4,095 ([9a40c94f](https://github.com/jyounce/rapid-build/commit/9a40c94f))
* **option:** add option minify.css.splitMinFile to disable the splitting of the styles.min.css ([686b3fd4](https://github.com/jyounce/rapid-build/commit/686b3fd4))


## 0.13.0 (2015-06-30)


#### Bug Fixes

* **option:**
  * change option spa.exclude to spa.placeholders, makes more sense ([395cd37b](https://github.com/jyounce/rapid-build/commit/395cd37b))
  * change option angular.templateCache.dev.enable to angular.templateCache.dev ([dd7a7f8a](https://github.com/jyounce/rapid-build/commit/dd7a7f8a))


#### Features

* **options:** add options spa.exclude.scripts and styles, exclude from spa.html file and min files ([5273bb60](https://github.com/jyounce/rapid-build/commit/5273bb60))


## 0.12.0 (2015-06-26)


#### Features

* **angular:** add option angular.httpBackend to enable angular mocks ([4688281f](https://github.com/jyounce/rapid-build/commit/4688281f))


### 0.11.1 (2015-06-24)


#### Bug Fixes

* **less:** npm update required, do not send less imports to the dist folder ([d3742e6f](https://github.com/jyounce/rapid-build/commit/d3742e6f))


## 0.11.0 (2015-06-23)


#### Features

* **options:** add minification options via the minify object ([bc288dc6](https://github.com/jyounce/rapid-build/commit/bc288dc6))


## 0.10.0 (2015-06-17)


#### Bug Fixes

* **options:** fix options dist.client.dir and dist.server.dir ([99564c24](https://github.com/jyounce/rapid-build/commit/99564c24))
* **prod build:** fix the loading order of scripts and styles ([6aad6b90](https://github.com/jyounce/rapid-build/commit/6aad6b90))


#### Features

* **options:** change option spa.exclude value to be an array of strings ([171426ff](https://github.com/jyounce/rapid-build/commit/171426ff))


## 0.9.0 (2015-06-16)


#### Features

* **options:** add ability to exclude angular files from the build ([7d06c14c](https://github.com/jyounce/rapid-build/commit/7d06c14c))


## 0.8.0 (2015-06-14)


#### Bug Fixes

* **config:** change config option name spaFile to spa ([0dbd5dca](https://github.com/jyounce/rapid-build/commit/0dbd5dca))


#### Features

* **options:** add option to use a custom spa file and not the build system's ([763322ca](https://github.com/jyounce/rapid-build/commit/763322ca))


## 0.7.0 (2015-06-11)


#### Features

* **plumber:** add the plumber to the lang compilers so the watch doesn't break on an error ([722750df](https://github.com/jyounce/rapid-build/commit/722750df))


## 0.6.0 (2015-06-11)


#### Features

* **libs:** add support for client 3rd party libs and move bower comps to bower_components ([41d671f4](https://github.com/jyounce/rapid-build/commit/41d671f4))


## 0.5.0 (2015-06-09)


#### Features

* **bower:** add support for bower packages dependencies ([24f761da](https://github.com/jyounce/rapid-build/commit/24f761da))
* **config:** add ability to change angular version via config ([2f6e2690](https://github.com/jyounce/rapid-build/commit/2f6e2690))


## 0.4.0 (2015-06-05)


#### Features

* **config:** add angular option to change the module name and add additional modules ([aeaa8c1b](https://github.com/jyounce/rapid-build/commit/aeaa8c1b))


## 0.3.0 (2015-06-05)


#### Features

* **angular:** add template cache options dev.enable and useAbsolutePaths to config ([dc48e5b2](https://github.com/jyounce/rapid-build/commit/dc48e5b2))
* **bower:** start of app support for bower ([74825ef8](https://github.com/jyounce/rapid-build/commit/74825ef8))
* **watch:** add support for watching the template cache ([b6237f21](https://github.com/jyounce/rapid-build/commit/b6237f21))


## 0.2.0 (2015-05-29)


#### Features

* **changelog:** add it ([52058a02](https://github.com/jyounce/rapid-build/commit/52058a02))


### 0.1.4 (2015-05-28)


#### Bug Fixes

* **gulp:** make gulp a dep if app is using gulp ([4184bf41](https://github.com/jyounce/rapid-build/commit/4184bf41))


### 0.1.3 (2015-05-27)


#### Bug Fixes

* **gulp:** load gulp from app's node_modules if present ([91cd0adc](https://github.com/jyounce/rapid-build/commit/91cd0adc))


### 0.1.2 (2015-05-27)


#### Bug Fixes

* **windows:** paths in spa html file ([e41d7a76](https://github.com/jyounce/rapid-build/commit/e41d7a76))


### 0.1.1 (2015-05-26)


#### README Update

* **readme:** remove duplicate description ([c9b11f7c](https://github.com/jyounce/rapid-build/commit/c9b11f7c))


## 0.1.0 (2015-05-26)


#### Initial Release

* **init:** rapid-build ([31a96692](https://github.com/jyounce/rapid-build/commit/31a96692))

