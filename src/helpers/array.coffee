module.exports =
	areEqual: (array1, array2, order=false) ->
		return false unless Array.isArray array1
		return false unless Array.isArray array2
		return false if array1.length isnt array2.length
		if order then array1.sort(); array2.sort()
		JSON.stringify(array1) is JSON.stringify array2