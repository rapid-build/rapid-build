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
var config = {} // config documentation coming soon
var rapid = require('rapid-build')(config) // init to pass in config options

// rapid returns a promise and has 1 optional param 'dev' or 'prod'
rapid().then(function() {
	console.log('whatever you want')
})
```
OR

```javascript
// if you are running gulp there are 3 available tasks
var config = {} // config documentation coming soon
require('rapid-build')(config)
gulp 'rapid-build'
gulp 'rapid-build:dev'
gulp 'rapid-build:prod'
```
#### Develop Rapidly!
![Shake and Bake!](docs/shake-and-bake.jpg)
