#global require, define
define ['angular', 'firebase'], (anfular, Firebase) ->

  'use strict'

  ###
    The main controller for the app. The controller:
    - retrieves and persists the model via the $firebase service
    - exposes the model to the template and provides event handlers
  ###
  ($scope, $location, $firebase, $speechRecognition, $speechSynthetis) ->
    fireRef = new Firebase('https://vocalist.firebaseio.com')

    $scope.$watch 'songs', ->
      total = 0
      remaining = 0
      $scope.songs.$getIndex().forEach (id) ->
        song = $scope.songs[id]
        if not song
          return

        total++
        if song.completed == false
          remaining++
      $scope.totalCount = total
      $scope.remainingCount = remaining
      $scope.completedCount = total - remaining
      $scope.allChecked = remaining == 0
    , true

    $scope.addSong = ->
      newSong = $scope.newSong.trim()
      if not newSong.length
        return
      $scope.songs.$add
        title: newSong
        completed: false
      $scope.newSong = ''

    $scope.editSong = (id) ->
      if id == $scope.playing.songId
        return
      editedSong = $scope.songs[id]
      if editedSong.completed
        return
      $scope.editedSong = editedSong
      $scope.originalSong = angular.extend({}, editedSong)

    $scope.doneEditing = (id) ->
      $scope.editedSong = null
      title = $scope.songs[id].title.trim()
      if title
        $scope.songs.$save(id)
      else
        $scope.removeSong(id)

    $scope.revertEditing = (id) ->
      $scope.songs[id] = $scope.originalSong
      $scope.doneEditing(id)

    $scope.removeSong = (id) ->
      $scope.songs.$remove(id)

    $scope.toggleCompleted = (id) ->
      song = $scope.songs[id]
      song.completed = not song.completed
      $scope.songs.$save(id)

    $scope.nextSong = ->
      $scope.stopMusic()
      id = $scope.playing?.songId
      song = $scope.songs[id]
      if song
        song.completed = true
      setTimeout ->
        $scope.startMusic()
        $scope.$apply()
      , 1000

    $scope.startMusic = ->
      $scope.playing.$child('shouldPlay').$set(true)

    $scope.stopMusic = ->
      $scope.playing.$set shouldPlay: false

    $scope.clearCompletedSongs = ->
      angular.forEach $scope.songs.$getIndex(), (id) ->
        if $scope.songs[id].completed
          $scope.songs.$remove(id)

    $scope.newSong = ''
    $scope.editedSong = null

    if $location.path() == ''
      $location.path('/')
    $scope.location = $location

    # Bind the songs to the firebase provider.
    $scope.songs = $firebase(fireRef.child('playlist'))

    $scope.playing = $firebase(fireRef.child('playing'))

    ###
      Need to be added for speech recognition
    ###

    findSong = (title) ->
      $scope.songs.$getIndex().forEach (id) ->
        song = $scope.songs[id]
        if song.title == title
          return id
      return

    completeSong = (title) ->
      id = findSong(title)
      if id
        song = $scope.songs[id]
        song.completed = not song.completed
        $scope.toggleCompleted(id)
        $scope.$apply()
        return true

    LANG = 'en-US'
    $speechRecognition.onstart (e) ->
      $speechSynthetis.speak('What songs do you want to play?', LANG)

    $speechRecognition.onerror (e) ->
      error = e.error || ''
      alert('An error occurred ' + error)

    $speechRecognition.payAttention()
    $speechRecognition.setLang(LANG)
    $speechRecognition.listen()

    $speechRecognition.onUtterance (utterance) ->
      console.log utterance

    $scope.recognition = recognition = {}
    $scope.recognition[LANG] =
      playSong:
        regex: /^play .+/gi
        lang: LANG
        call: (utterance) ->
          parts = utterance.split(' ')
          if parts.length > 1
            $scope.newSong = parts.slice(1).join(' ')
            $scope.addSong()
            $scope.$apply()
      startMusic:
        regex: /start.*music/gi
        lang: LANG
        call: (utterance) ->
          $scope.startMusic()
          $scope.$apply()
      stopMusic:
        regex: /stop.*music/gi
        lang: LANG
        call: (utterance) ->
          $scope.stopMusic()
          $scope.$apply()
      clearCompleted:
        regex: /clear.*/gi
        lang: LANG
        call: (utterance) ->
          $scope.clearCompletedSongs()
          $scope.$apply()
      next:
        regex: /next.*/gi
        lang: LANG
        call: (utterance) ->
          $scope.nextSong()
          $scope.$apply()
      listTasks: [
        {
          regex: /^remove .+/gi
          lang: LANG,
          call: (utterance) ->
            # TODO: only do for not complete
            parts = utterance.split(' ')
            if parts.length > 1
              title = parts[1...].join(' ')
              id = findSong(title)
              if id
                $scope.removeSong(id)
                $scope.$apply()
        }
      ]

    ignoreUtterance = {}
    for k, v of recognition[LANG]
      if v instanceof Array
        continue
      ignoreUtterance[k] = $speechRecognition.listenUtterance(v)

    ###
     to ignore listener call returned function
    ###
    # ignoreUtterance['addToList']()
