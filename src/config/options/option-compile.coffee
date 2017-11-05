module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init compile options
	# ====================
	compile = options.compile
	compile = {} unless isType.object compile

	compile.htmlImports = {} unless isType.object compile.htmlImports
	compile.htmlImports.client = {} unless isType.object compile.htmlImports.client
	compile.htmlImports.client.enable = false unless isType.boolean compile.htmlImports.client.enable

	compile.htmlScripts = {} unless isType.object compile.htmlScripts
	compile.htmlScripts.client = {} unless isType.object compile.htmlScripts.client
	compile.htmlScripts.client.enable = false unless isType.boolean compile.htmlScripts.client.enable

	compile.typescript = {} unless isType.object compile.typescript
	compile.typescript.client = {} unless isType.object compile.typescript.client
	compile.typescript.server = {} unless isType.object compile.typescript.server
	compile.typescript.client.enable  = false unless isType.boolean compile.typescript.client.enable
	compile.typescript.server.enable  = false unless isType.boolean compile.typescript.server.enable
	compile.typescript.client.entries = null  unless isType.array compile.typescript.client.entries

	# add compile options
	# ===================
	options.compile = compile

	# return
	# ======
	options


