angular.module('rapid-build').constant 'GETTING_STARTED',
	'Dependencies':
		icon: 'fa-check-circle'
		info: 'these must be installed first'
		items: [
			label: '<a target="_blank" href="https://git-scm.com/downloads">
						<rb:icon kind="fa-code-fork"></rb:icon> Git
					</a>'
		,
			label: '<a target="_blank" href="https://nodejs.org/">
						<rb:icon kind="ion-social-nodejs"></rb:icon> Node.js
					</a>'
			info: 'version >= 4.0.0'
		]

	'Installation':
		icon: 'fa-download'
		items: [
			class: 'nomark'
			label: '<h6>
						global install recommended
						<em class="sub sep parens">global install benefits</em>
					</h6>'
		,
			label: 'One time install.'
			info: 'the install is fairly big'
		,
			label: 'Can be used for multiple projects.'
		,
			label: '<rb:icon kind="fa-exclamation-circle"></rb:icon>
					If installing globally you may need to set your
					<a target="_blank" href="https://nodejs.org/api/modules.html#modules_loading_from_the_global_folders">NODE_PATH</a>'
		]
		example:
			lang: 'bash'
			code: """
				$ npm install rapid-build -g
			"""

	'Directory Structure':
		icon: 'fa-folder-open'
		items: [
			label: '<rb:icon kind="fa-exclamation-circle"></rb:icon>
					Everthing is optional besides package.json and
					<a href="#build.js" rb-scroll>build.js</a>'
		,
			label: 'The directory names can be configured,
					see build option <a href="/build-options#src">src</a>.'
		]
		example:
			hideLang: 'true'
			lang: 'coffee'
			code: """
				dist/ # (generated distributable folder created by rapid-build)
				src/
				├── client/
				│   ├── bower_components/ # (generated folder via bower.json)
				│   ├── images/
				│   │   └── gif, jpg, jpeg, png, etc..
				│   ├── libs/
				│   │   └── # (3rd party libraries that aren't bower components)
				│   ├── scripts/
				│   │   └── coffee, es6 or js
				│   ├── styles/
				│   │   └── css, less, sass or scss
				│   ├── test/
				│   │   └── coffee, es6 or js
				│   ├── views/
				│   │   └── html
				│   └── spa.html # (optional, see build options spa.src.filePath)
				└── server/
				    ├── test/
				    │   └── coffee, es6 or js
				    └── routes.{coffee,es6,js} # (optional, see build options dist.server.fileName)
				nodes_modules/ # (generated folder via package.json)
				bower.json
				build.js
				build-options.js
				package.json
			"""

	'build.js':
		icon: 'ion-settings'
		iconSize: 'large'
		info: 'required'
		items: [
			label: '<rb:icon kind="fa-exclamation-circle"></rb:icon>
					build.js is required to run the build.'
		,
			label: 'Copy this and save it to the root of your project.'
			items: [
				label: 'See <a href="#build-options.js" rb-scroll>build-options.js</a>
						for customizing your builds.'
			]
		]
		example:
			lang: 'js'
			code: """
				/* build.js
				 ***********/
				var getBuildType = type => {
					if (typeof type !== 'string') return 'default';
					return type.toLowerCase();
				};

				var getBuildOptions = type => {
					try { return require('./build-options.js')(type); }
					catch(e) { return {}; }
				};

				var buildType = getBuildType(process.argv[2]),
					options   = getBuildOptions(buildType),
					build     = require('rapid-build')(options);

				/* Run build by typing one of the following in the console:
				 * node build
				 * node build dev  | dev:test    | dev:test:client  | dev:test:server
				 * node build prod | prod:test   | prod:test:client | prod:test:server | prod:server
				 * node build test | test:client | test:server
				 ************************************************************************************/
				build(buildType).then(() => {
					console.log('Build Complete!');
				});
			"""

	'build-options.js':
		icon: 'fa-cogs'
		items: [
			label: 'More than likely you will need to customize your builds.'
			info: 'No problem!'
		,
			label: 'There are many options available for you, see
					<a href="/build-options">build options</a>.'
		,
			label: 'Copy this and save it to the root of your project.'
			items: [
				label: 'build-options.js gets required from
						<a href="#build.js" rb-scroll>build.js</a>'
			,
				label: '<rb:icon kind="fa-exclamation-circle"></rb:icon>
						This is where you will add your
						<a href="/build-options">build options</a>.'
			]
		]
		example:
			lang: 'js'
			code: """
				/* build-options.js
				 *******************/
				var getCommonOptions = () => {
					// Add shared dev and prod build options here:
					return {
						// spa: { src: { filePath: 'spa.html' } } // example
					};
				};

				var setDevOptions = options => {
					// Add dev specific build options here:
					// options.angular = { templateCache: { dev: true } }; // example
				};

				var setProdOptions = options => {
					// Add dev specific build options here:
					// options.minify = { css: { splitMinFile: false } }; // example
				};

				var getOptions = buildType => {
					var options = getCommonOptions();
					if (buildType.indexOf('prod') != -1) setProdOptions(options);
					else setDevOptions(options);
					return options;
				}

				module.exports = getOptions
			"""




