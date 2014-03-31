define [
  'app/playlist',
  'c/playlistCtrl',
  'd/onFocus',
  'd/onBlur',
  'd/onEscape'
], (playlist, playlistCtrl, onFocus, onBlur, onEscape) ->
  playlist
    .controller 'PlaylistCtrl', playlistCtrl
    .directive 'onFocus', onFocus
    .directive 'onBlur', onBlur
    .directive 'onEscape', onEscape