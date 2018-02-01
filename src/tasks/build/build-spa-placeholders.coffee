module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.spa.autoInject

	# requires
	# ========
	q        = require 'q'
	fse      = require 'fs-extra'
	SPA_PATH = config.spa.temp.path

	Placeholders = {
		'scripts'
		'styles'
		'moduleName' # value for ng-app
		'ngCloakStyles'
		'clickjacking'
	}
	Needle =
		comments:
			'BUILD_TEMP_PLACEHOLDER_COMMENT'
		placeholders:
			left: '<!--#include ', right: '-->'

	# helpers
	# =======
	Has =
		ph: (content, ph) ->
			content.indexOf(ph) isnt -1

		attr: (attr, content) ->
			content.indexOf(attr) isnt -1

	Format =
		phs: (phs) ->
			for key, val of phs
				phs[key] = "#{Needle.placeholders.left}#{val}#{Needle.placeholders.right}"
			phs

		closing: # last closing tag
			tag: (tag, ph) ->
				return null unless tag
				before = '\n\t'
				after  = '\n'
				"#{before}#{ph}#{after}#{tag}"

		opening: # first opening tag
			tag: (tag, ph) ->
				return null unless tag
				before = '\n\t'
				after  = '\n'
				"#{tag}#{before}#{ph}#{after}"

		before: # first opening tag
			tag: (tag, ph) ->
				return null unless tag
				before = ''
				after  = '\n\n'
				"#{before}#{ph}#{after}#{tag}"

		attr: (tag, ph, attr) ->
			return null unless tag
			lastIndex = tag.lastIndexOf '>'
			tag       = tag.substring(0, lastIndex).trim()
			tag      += " #{attr}=\"#{ph}\">"

	Pats =
		closing:
			tag: (tag) ->
				tag        = '.*?' if tag is '*'
				tagPat     = "<\\s*\/\\s*#{tag}\\s*>"
				lastTagPat = '?![\\s\\S]*'
				new RegExp "#{tagPat}(#{lastTagPat}#{tagPat})", 'i'
		opening:
			tag: (tag) ->
				tag = '.*?' if tag is '*'
				new RegExp "<\\s*#{tag}(-->|.|\\s)*?>", 'i'

		before:
			tag: (tag) ->
				Pats.opening.tag tag

		comments:
			html:
				new RegExp '<!--(.|\\s)*?-->', 'ig'
			needle:
				new RegExp Needle.comments, 'g'

	Get =
		content:
			tag: (ph, content, tags) ->
				return content if Has.ph content, ph
				for tag, loc of tags
					pat     = Pats[loc].tag tag
					locTag  = Get.tag pat, ph, loc, content
					continue unless locTag
					content = content.replace pat, locTag
					break
				content

			attr: (ph, attr, content, tags) ->
				return content if Has.ph content, ph
				return content if Has.attr attr, content
				for tag in tags
					method  = if tag is '*' then 'anyAttr' else 'indAttr'
					info    = Get.content[method] ph, attr, content, tag
					continue unless info.oTag
					content = info.content
					break
				content

			indAttr: (ph, attr, content, tag) -> # specific tag
				info = { oTag: null, content }
				pat  = Pats.opening.tag tag
				info.oTag = Get.attr pat, ph, attr, content # o = opening tag
				return info unless info.oTag
				info.content = info.content.replace pat, info.oTag
				info

			anyAttr: (ph, attr, content, tag) -> # any tag
				info        = { oTag: null, content }
				comments    = []
				pat         = Pats.opening.tag tag
				patCmtsHtml = Pats.comments.html
				content     = content.replace patCmtsHtml, (cmt) -> comments.push cmt; Needle.comments
				info.oTag   = Get.attr pat, ph, attr, content # o = opening tag
				return info unless info.oTag
				patCmtsNeedle = Pats.comments.needle
				info.content  = content.replace pat, info.oTag
				return info unless comments.length
				cmtCnt = -1
				info.content = info.content.replace patCmtsNeedle, -> cmtCnt++; comments[cmtCnt]
				info

		tag: (pat, ph, loc, content) ->
			match = pat.exec content
			return null unless match
			tag = match[0]
			tag = Format[loc].tag tag, ph

		attr: (pat, ph, attr, content) ->
			match = pat.exec content
			return null unless match
			tag = match[0]
			tag = Format.attr tag, ph, attr

		autoInject: (type) -> # :boolean
			injects = config.spa.autoInject
			return true if injects.indexOf('all') isnt -1
			injects.indexOf(type) isnt -1

	# tasks
	# =====
	tasks =
		getContent: -> # :Promise<string>
			fse.readFile(SPA_PATH).then (file) ->
				file.toString()

		updateContent: (content) -> # :Promise<string>
			phs     = Format.phs Placeholders
			content = tasks.update.clickjacking  content, phs.clickjacking  if Get.autoInject 'clickjacking'
			content = tasks.update.styles        content, phs.styles        if Get.autoInject 'styles'
			content = tasks.update.ngCloakStyles content, phs.ngCloakStyles if Get.autoInject 'ngCloakStyles'
			content = tasks.update.scripts       content, phs.scripts       if Get.autoInject 'scripts'
			content = tasks.update.moduleName    content, phs.moduleName    if Get.autoInject 'moduleName'
			promiseHelp.get content

		createSpa: (content) -> # :Promise<Object>
			fse.outputFile(SPA_PATH, content).then ->
				message: 'created spa file'

		update:
			clickjacking: (content, ph) ->
				Get.content.tag(
					ph
					content
					head: 'closing', body: 'closing', '*': 'before'
				)

			scripts: (content, ph) ->
				Get.content.tag(
					ph
					content
					body: 'closing', head: 'closing', '*': 'closing'
				)

			styles: (content, ph) ->
				Get.content.tag(
					ph
					content
					head: 'closing', body: 'opening', '*': 'before'
				)

			ngCloakStyles: (content, ph) ->
				Get.content.tag(
					ph
					content
					head: 'closing', body: 'opening', '*': 'before'
				)

			moduleName: (content, ph) ->
				return content if config.angular.bootstrap.enabled
				Get.content.attr(
					ph
					'ng-app'
					content
					['html', 'body', '*']
				)

	# API
	# ===
	api =
		runTask: -> # synchronously
			_tasks = [
				-> tasks.getContent()
				(content) -> tasks.updateContent content
				(content) -> tasks.createSpa content
			]
			_tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: 'built spa placeholders'

	# return
	# ======
	api.runTask()



