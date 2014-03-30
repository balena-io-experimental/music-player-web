define [
  'app/todomvc',
  'c/todoCtrl',
  'd/todoFocus',
  'd/todoBlur',
  'd/todoEscape'
], (todomvc, todoCtrl, todoFocus, todoBlur, todoEscape) ->
  todomvc
    .controller 'TodoCtrl', todoCtrl
    .directive 'todoFocus', todoFocus
    .directive 'todoBlur', todoBlur
    .directive 'todoEscape', todoEscape