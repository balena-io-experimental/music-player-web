define(['vendor/jade-runtime'], function (jade){ var templates = {};

//
// Source file: [/Users/admin/Work/music-player-web-front-end/assets/javascripts/app/template/detail.jade]
// Template name: [detail]
//
templates['detail'] = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

buf.push("<form name=\"myForm\" role=\"form\"><div ng-class=\"{'has-error': myForm.name.$invalid &amp;&amp; !myForm.name.$pristine}\" class=\"form-group\"><label for=\"inputName\">Name</label><input id=\"inputName\" type=\"text\" name=\"name\" ng-model=\"project.name\" required=\"required\" class=\"form-control\"/><div ng-show=\"myForm.name.$error.required &amp;&amp; !myForm.name.$pristine\" class=\"help-block\">Required</div></div><div ng-class=\"{'has-error': myForm.site.$invalid &amp;&amp; !myForm.site.$pristine}\" class=\"form-group\"><label for=\"inputUrl\">Website</label><input id=\"inputUrl\" type=\"url\" name=\"site\" ng-model=\"project.site\" required=\"required\" class=\"form-control\"/><div ng-show=\"myForm.site.$error.required &amp;&amp; !myForm.name.$pristine\" class=\"help-block\">Required</div><div ng-show=\"myForm.site.$error.url\" class=\"help-block\">Not a URL</div></div><label>Description</label><textarea name=\"description\" ng-model=\"project.description\" class=\"form-control\"></textarea><div><a href=\"#/\" class=\"btn btn-link\">Cancel</a><button type=\"button\" ng-click=\"save()\" ng-disabled=\"myForm.$invalid\" class=\"btn btn-primary\">Save</button><button type=\"button\" ng-click=\"destroy()\" ng-show=\"project.$remove\" class=\"btn btn-danger\">Delete</button></div></form>");;return buf.join("");
}

//
// Source file: [/Users/admin/Work/music-player-web-front-end/assets/javascripts/app/template/list.jade]
// Template name: [list]
//
templates['list'] = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

buf.push("<p><input type=\"text\" ng-model=\"search\" placeholder=\"Search\" class=\"form-control search-query\"/></p><table class=\"table table-striped\"><thead><tr><th>Project</th><th>Description</th><th><a href=\"#/new\"><span class=\"glyphicon glyphicon-plus-sign\"></span></a></th></tr></thead><tbody><tr ng-repeat=\"project in projects | orderByPriority | filter:search | orderBy:'name'\"><td><a href=\"{{project.site}}\" target=\"_blank\">{{project.name}}</a></td><td>{{project.description}}</td><td><a href=\"#/edit/{{project.$id}}\"><span class=\"glyphicon glyphicon-pencil\"></span></a></td></tr></tbody></table>");;return buf.join("");
}
return templates; });