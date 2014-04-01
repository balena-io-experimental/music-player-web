define [
  'app/playlist',
  'c/playlistCtrl',
  'd/focusIf',
  'd/onBlur',
  'd/onEscape'
], (playlist, playlistCtrl, focusIf, onBlur, onEscape) ->
  playlist
    .controller 'PlaylistCtrl', playlistCtrl
    .directive 'focusIf', focusIf
    .directive 'onBlur', onBlur
    .directive 'onEscape', onEscape