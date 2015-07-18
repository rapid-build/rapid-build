# Do not check this file in.
# It gets generated from /templates/inject-angular-mocks.tpl
# ==========================================================
if angular.module('<%= moduleName %>').requires.indexOf('ngMockE2E') is -1
	angular.module('<%= moduleName %>').requires.push 'ngMockE2E'