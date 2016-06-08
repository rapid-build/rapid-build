# Angular Bootstrap
# =================
do ->
	return if typeof angular is 'undefined'
	<% if (!!elm) { %>
	elm = document.querySelector '<%= elm %>'
	angular.element(elm).ready ->
		angular.bootstrap elm, ['<%= moduleName %>']
	<% } else { %>
	angular.element(document).ready ->
		angular.bootstrap document, ['<%= moduleName %>']
	<% } %>