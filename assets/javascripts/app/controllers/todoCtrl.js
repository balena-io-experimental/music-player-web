/*global require, define */
define(['angular', 'firebase'], function (
  anfular, Firebase
) {

  'use strict';

  /**
   * The main controller for the app. The controller:
   * - retrieves and persists the model via the $firebase service
   * - exposes the model to the template and provides event handlers
   */
  return function TodoCtrl($scope, $location, $firebase, $speechRecognition) {
    var fireRef = new Firebase('https://vocalist.firebaseio.com');

    $scope.$watch('todos', function() {
      var total = 0;
      var remaining = 0;
      $scope.todos.$getIndex().forEach(function(index) {
        var todo = $scope.todos[index];
        // Skip invalid entries so they don't break the entire app.
        if (!todo || !todo.title) {
          return;
        }

        total++;
        if (todo.completed === false) {
          remaining++;
        }
      });
      $scope.totalCount = total;
      $scope.remainingCount = remaining;
      $scope.completedCount = total - remaining;
      $scope.allChecked = remaining === 0;
    }, true);

    $scope.addTodo = function() {
      var newTodo = $scope.newTodo.trim();
      if (!newTodo.length) {
        return;
      }
      $scope.todos.$add({
        title: newTodo,
        completed: false
      });
      $scope.newTodo = '';
    };

    $scope.editTodo = function(id) {
      $scope.editedTodo = $scope.todos[id];
      $scope.originalTodo = angular.extend({}, $scope.editedTodo);
    };

    $scope.doneEditing = function(id) {
      $scope.editedTodo = null;
      var title = $scope.todos[id].title.trim();
      if (title) {
        $scope.todos.$save(id);
      } else {
        $scope.removeTodo(id);
      }
    };

    $scope.revertEditing = function(id) {
      $scope.todos[id] = $scope.originalTodo;
      $scope.doneEditing(id);
    };

    $scope.removeTodo = function(id) {
      $scope.todos.$remove(id);
    };

    $scope.toggleCompleted = function(id) {
      var todo = $scope.todos[id];
      todo.completed = !todo.completed;
      $scope.todos.$save(id);
    };

    $scope.clearCompletedTodos = function() {
      angular.forEach($scope.todos.$getIndex(), function(index) {
        if ($scope.todos[index].completed) {
          $scope.todos.$remove(index);
        }
      });
    };

    $scope.markAll = function(allCompleted) {
      angular.forEach($scope.todos.$getIndex(), function(index) {
        $scope.todos[index].completed = !allCompleted;
      });
      $scope.todos.$save();
    };

    $scope.newTodo = '';
    $scope.editedTodo = null;

    if ($location.path() === '') {
      $location.path('/');
    }
    $scope.location = $location;

    // Bind the todos to the firebase provider.
    $scope.todos = $firebase(fireRef.child('playlist'));

    $scope.playing = $firebase(fireRef.child('playing'));

    /**
     * Need to be added for speech recognition
     */

    var findTodo = function(title) {
      var match = false
      var matches = $scope.todos.$getIndex().forEach(function(index) {
        var todo = $scope.todos[index];
        console.log(title, todo.title, todo.title === title);
        if (todo.title === title) {
          match = index;
        }
      });
      return match
    };

    var completeTodo = function(title) {
      $scope.todos.$getIndex().forEach(function(index) {
        var todo = $scope.todos[index];
        if (todo.title === title) {
          todo.completed = !todo.completed;
          $scope.toggleCompleted(index);
          $scope.$apply();
          return true;
        }
      });
    };

    var LANG = 'en-US';
    $speechRecognition.onstart(function(e) {
      $speechRecognition.speak('What songs do you want to play?');
    });
    $speechRecognition.onerror(function(e) {
      var error = (e.error || '');
      alert('An error occurred ' + error);
    });
    $speechRecognition.payAttention();
    // $speechRecognition.setLang(LANG);
    $speechRecognition.listen();

    $scope.recognition = {};
    $scope.recognition['en-US'] = {
      'addToList': {
        'regex': /^play .+/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          var parts = utterance.split(' ');
          if (parts.length > 1) {
            $scope.newTodo = parts.slice(1).join(' ');
            $scope.addTodo();
            $scope.$apply();
          }
        }
      },
      'start-music': {
        'regex': /start.*music/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $scope.playing.$set(true);
          $scope.$apply();
        }
      },
      'stop-music': {
        'regex': /stop.*music/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $scope.playing.$set(false);
          $scope.$apply();
        }
      },
      'show-all': {
        'regex': /show.*all/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $location.path('/');
          $scope.$apply();
        }
      },
      'show-active': {
        'regex': /show.*active/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $location.path('/active');
          $scope.$apply();
        }
      },
      'show-completed': {
        'regex': /show.*complete/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $location.path('/completed');
          $scope.$apply();
        }
      },
      'mark-all': {
        'regex': /^mark/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $scope.markAll(1);
          $scope.$apply();
        }
      },
      'unmark-all': {
        'regex': /^unmark/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $scope.markAll(1);
          $scope.$apply();
        }
      },
      'clear-completed': {
        'regex': /clear.*/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          $scope.clearCompletedTodos();
          $scope.$apply();
        }
      },
      'listTasks': [{
        'regex': /^complete .+/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          var parts = utterance.split(' ');
          if (parts.length > 1) {
            completeTodo(parts.slice(1).join(' '));
          }
        }
      }, {
        'regex': /^remove .+/gi,
        'lang': 'en-US',
        'call': function(utterance) {
          var parts = utterance.split(' ');
          if (parts.length > 1) {
            console.log(parts.slice(1).join(' '))
            var todo = findTodo(parts.slice(1).join(' '));
            console.log(todo);
            if (todo) {
              $scope.removeTodo(todo);
              $scope.$apply();
            }
          }
        }
      }]
    };

    var ignoreUtterance = {};
    ignoreUtterance['addToList'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['addToList']);
    ignoreUtterance['show-all'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['show-all']);
    ignoreUtterance['start-music'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['start-music']);
    ignoreUtterance['stop-music'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['stop-music']);
    ignoreUtterance['show-active'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['show-active']);
    ignoreUtterance['show-completed'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['show-completed']);
    ignoreUtterance['mark-all'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['mark-all']);
    ignoreUtterance['unmark-all'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['unmark-all']);
    ignoreUtterance['clear-completed'] = $speechRecognition.listenUtterance($scope.recognition['en-US']['clear-completed']);

    /*
     to ignore listener call returned function
     */
    // ignoreUtterance['addToList']();
  };
});