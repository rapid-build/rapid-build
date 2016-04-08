# build-buddy-starter
**Requirements**: npm package [build-buddy](http://aim-npm-server/)

## Installation
```bash
$ npm install build-buddy-starter
# OR (run this if building a clarity app)
$ npm install build-buddy-starter --type=clarity
```

## Description
This package is for the [build-buddy](http://aim-npm-server/).
Get up and running fast using the build-buddy.  
After install, your app root will contain 4 new files which you are free to modify:  

* **build.js** (probably won't need to modify)
* **build-options.js** (modifications might be needed, depends on what you are creating)
* **.gitignore** (modifications might be needed)
* **.npmignore** (modifications might be needed)

*Note: if these files already exists, they will not be overridden.*

## API and How to Use
```bash
# open your terminal and run one of the following builds provided by build-buddy
node build
node build test
node build test:client
node build test:server
node build dev
node build dev:test
node build dev:test:client
node build dev:test:server
node build prod
node build prod:server
node build prod:test
node build prod:test:client
node build prod:test:server
```

## Extra Build Option
```bash
# run in terminal
# append "ci" to any build type if
# you need custom configuration for your continuous integration job
# add custom configuration in build-options.js
# example:
node build prod ci
```