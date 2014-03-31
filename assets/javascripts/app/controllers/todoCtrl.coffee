#global require, define
define ['angular', 'firebase'], (anfular, Firebase) ->

  'use strict'

  ###
    The main controller for the app. The controller:
    - retrieves and persists the model via the $firebase service
    - exposes the model to the template and provides event handlers
  ###
  TodoCtrl = ($scope, $location, $firebase, $speechRecognition, $speechSynthetis) ->
    fireRef = new Firebase('https://vocalist.firebaseio.com')

    $scope.$watch 'todos', ->
      total = 0
      remaining = 0
      $scope.todos.$getIndex().forEach (index) ->
        todo = $scope.todos[index]
        # Skip invalid entries so they don't break the entire app.
        if not todo or not todo.title
          return

        total++
        if todo.completed == false
          remaining++
      $scope.totalCount = total
      $scope.remainingCount = remaining
      $scope.completedCount = total - remaining
      $scope.allChecked = remaining == 0
    , true

    $scope.addTodo = ->
      newTodo = $scope.newTodo.trim()
      if not newTodo.length
        return
      $scope.todos.$add
        title: newTodo
        completed: false
      $scope.newTodo = ''

    $scope.editTodo = (id) ->
      $scope.editedTodo = $scope.todos[id]
      $scope.originalTodo = angular.extend({}, $scope.editedTodo)

    $scope.doneEditing = (id) ->
      $scope.editedTodo = null
      title = $scope.todos[id].title.trim()
      if title
        $scope.todos.$save(id)
      else
        $scope.removeTodo(id)

    $scope.revertEditing = (id) ->
      $scope.todos[id] = $scope.originalTodo
      $scope.doneEditing(id)

    $scope.removeTodo = (id) ->
      $scope.todos.$remove(id)

    $scope.toggleCompleted = (id) ->
      todo = $scope.todos[id]
      todo.completed = not todo.completed
      $scope.todos.$save(id)

    $scope.clearCompletedTodos = ->
      angular.forEach $scope.todos.$getIndex(), (index) ->
        if $scope.todos[index].completed
          $scope.todos.$remove(index)

    $scope.markAll = (allCompleted) ->
      angular.forEach $scope.todos.$getIndex(), (index) ->
        $scope.todos[index].completed = not allCompleted
      $scope.todos.$save()

    $scope.newTodo = ''
    $scope.editedTodo = null

    if $location.path() == ''
      $location.path('/')
    $scope.location = $location;

    # Bind the todos to the firebase provider.
    $scope.todos = $firebase(fireRef.child('playlist'))

    $scope.playing = $firebase(fireRef.child('playing'))

    ###
      Need to be added for speech recognition
    ###

    findTodo = (title) ->
      match = false
      matches = $scope.todos.$getIndex().forEach (index) ->
        todo = $scope.todos[index]
        console.log(title, todo.title, todo.title == title)
        if todo.title == title
          match = index
      return match

    completeTodo = (title) ->
      $scope.todos.$getIndex().forEach (index) ->
        todo = $scope.todos[index]
        if todo.title == title
          todo.completed = not todo.completed
          $scope.toggleCompleted(index)
          $scope.$apply()
          return true

    LANG = 'en-US'
    $speechRecognition.onstart (e) ->
      $speechSynthetis.speak('What songs do you want to play?', LANG)

    $speechRecognition.onerror (e) ->
      debugger
      error = e.error || ''
      alert('An error occurred ' + error)
    $speechRecognition.payAttention()
    #$speechRecognition.setLang(LANG)
    $speechRecognition.listen()

    $scope.recognition = {}
    $scope.recognition[LANG] =
      'addToList':
        regex: /^play .+/gi
        lang: LANG
        call: (utterance) ->
          parts = utterance.split(' ')
          if parts.length > 1
            $scope.newTodo = parts.slice(1).join(' ')
            $scope.addTodo()
            $scope.$apply()
      'start-music':
        regex: /start.*music/gi
        lang: LANG
        call: (utterance) ->
          $scope.playing.$set(true)
          $scope.$apply()
      'stop-music':
        regex: /stop.*music/gi
        lang: LANG
        call: (utterance) ->
          $scope.playing.$set(false)
          $scope.$apply()
      'show-all':
        regex: /show.*all/gi
        lang: LANG
        call: (utterance) ->
          $location.path('/')
          $scope.$apply()
      'show-active':
        regex: /show.*active/gi
        lang: LANG
        call: (utterance) ->
          $location.path('/active')
          $scope.$apply()
      'show-completed':
        regex: /show.*complete/gi,
        lang: LANG
        call: (utterance) ->
          $location.path('/completed')
          $scope.$apply()
      'mark-all':
        regex: /^mark/gi
        lang: LANG
        call: (utterance) ->
          $scope.markAll(1)
          $scope.$apply()
      'unmark-all':
        regex: /^unmark/gi
        lang: LANG
        call: (utterance) ->
          $scope.markAll(1)
          $scope.$apply()
      'clear-completed':
        regex: /clear.*/gi
        lang: LANG
        call: (utterance) ->
          $scope.clearCompletedTodos()
          $scope.$apply()
      listTasks: [
        {
          regex: /^complete .+/gi
          lang: LANG
          call: (utterance) ->
            parts = utterance.split(' ')
            if parts.length > 1
              completeTodo(parts.slice(1).join(' '))
        }
        {
          regex: /^remove .+/gi
          lang: LANG,
          call: (utterance) ->
            parts = utterance.split(' ')
            if parts.length > 1
              console.log(parts.slice(1).join(' '))
              todo = findTodo(parts.slice(1).join(' '))
              console.log(todo)
              if todo
                $scope.removeTodo(todo)
                $scope.$apply()
        }
      ]

    ignoreUtterance = {}
    ignoreUtterance['addToList'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['addToList']);
    ignoreUtterance['show-all'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['show-all']);
    ignoreUtterance['start-music'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['start-music']);
    ignoreUtterance['stop-music'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['stop-music']);
    ignoreUtterance['show-active'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['show-active']);
    ignoreUtterance['show-completed'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['show-completed']);
    ignoreUtterance['mark-all'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['mark-all']);
    ignoreUtterance['unmark-all'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['unmark-all']);
    ignoreUtterance['clear-completed'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['clear-completed']);

    ###
     to ignore listener call returned function
    ###
    # ignoreUtterance['addToList']();
