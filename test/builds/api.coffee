# test: build modes
# =================
module.exports =
	default: [
		'/common/common'
		'/common/common-client'
		'/common/common-server'
		'/build/build-spa'
		'/server/start-server'
	]
	dev: [
		'/common/common'
		'/common/common-client'
	]
	prod: [
		'/common/common'
		'/common/common-client'
	]