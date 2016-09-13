/* BUILDER ENTRY
 * compile src to dist
 * dist will contain compiled package
 *************************************/
require('ts-node/register')
var builder = require('./Builder').instance

/* BUILD DIST
 *************/
builder.build()
// .then(() => {
// 	console.log('PACKAGE DIST CREATED'.attn);
// })
// .catch(e => {
// 	console.error('FAILED TO CREATE PACKAGE DIST'.error);
// 	console.error(`Error: ${e.message}`.error);
// })