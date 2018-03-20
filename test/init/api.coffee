# test: build mode tasks
# ======================
module.exports =
	default: [
		'/common/common'
		'/common/common-client'
		'/common/common-server'
		'/server/start-server'
		# '/browser/open-browser' # TODO
		'/server/stop-server'
	]
	dev: [
		'/common/common'
		'/common/common-client'
		'/common/common-server'
		'/server/start-server-dev'
		'/browser/browser-sync'
		'/watch/watch'
	]
	prod: [ # TODO
		'/common/common'
		'/common/common-client'
	]