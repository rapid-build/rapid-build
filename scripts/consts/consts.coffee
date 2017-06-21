# HELPER CONSTANTS
# ================
path = require 'path'

# consts
# ======
RB_ROOT                = path.resolve __dirname, '..', '..'
RB_LIB                 = path.join RB_ROOT, 'lib'
RB_SRC                 = path.join RB_ROOT, 'src'
RB_LIB_SERVER          = path.join RB_LIB, 'src', 'server'
RB_SRC_SERVER          = path.join RB_SRC, 'src', 'server'
RB_LIB_SERVER_PKG_NAME = 'server.tgz'
RB_LIB_SERVER_PKG      = path.join RB_LIB_SERVER, RB_LIB_SERVER_PKG_NAME

# module
# ======
module.exports = {
	RB_ROOT
	RB_LIB
	RB_SRC
	RB_LIB_SERVER
	RB_SRC_SERVER
	RB_LIB_SERVER_PKG
	RB_LIB_SERVER_PKG_NAME
}