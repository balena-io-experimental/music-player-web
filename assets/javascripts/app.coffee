define [
  'app/playlist',
  'c/playlistCtrl',
  'd/onFocus',
  'd/onBlur',
  'd/onEscape'
], (playlist, playlistCtrl, todoFocus, todoBlur, todoEscape) ->
  playlist
    .controller 'PlaylistCtrl', playlistCtrl
    .directive 'todoFocus', todoFocus
    .directive 'todoBlur', todoBlur
    .directive 'todoEscape', todoEscape