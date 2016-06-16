# https://github.com/easy-node/angular-uid/tree/v0.1.1
# ====================================================
angular.module('rapid-build').service 'uidService', [->
	# private
	# =======
	uid = ['0', '0', '0']

	# methods
	# =======
	@next = ->
		index = uid.length
		digit = undefined
		while index
			index--
			digit = uid[index].charCodeAt 0
			if digit == 57
				uid[index] = 'A'
				return uid.join('')
			if digit == 90
				uid[index] = '0'
			else
				uid[index] = String.fromCharCode(digit + 1)
				return uid.join('')
		uid.unshift '0'
		uid.join ''

	@

]