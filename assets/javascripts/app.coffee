define [
  'app/todomvc',
  'c/todoCtrl',
  'd/onFocus',
  'd/onBlur',
  'd/onEscape'
], (todomvc, todoCtrl, todoFocus, todoBlur, todoEscape) ->
  todomvc
    .controller 'TodoCtrl', todoCtrl
    .directive 'todoFocus', todoFocus
    .directive 'todoBlur', todoBlur
    .directive 'todoEscape', todoEscape