(function () {

var adaptive = angular.module('adaptive.speech', []);

adaptive.value('DEST_LANG', 'en-US');

adaptive.factory('$speechRecognition', ['$rootScope', 'DEST_LANG', function ($rootScope, DEST_LANG) {

  var SpeechRecognitionMock = function(){
    this.start = function() { this.onerror({'code': 0, 'error': 'speech recognition is not supported'}); }.bind(this);
    this.stop = function() { this.onerror({'code': 0, 'error': 'speech recognition is not supported'}); }.bind(this);
  };

  window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition || SpeechRecognitionMock;

  var recognizer;

  var init = function(){
    recognizer = new window.SpeechRecognition();
    recognizer.continuous = true;
    recognizer.interimResults = true;
    recognizer.maxAlternatives = 3;

    recognizer.onresult = function(e) {
      if (onresult) {
        onresult(e);
      }
    };

    recognizer.onstart = function(e) {
      console.log('listening...');
      if (onstart) {
        onstart(e);
      }
    };

    recognizer.onend = function(e) {
      if (onend) {
        onend(e);
      }
    };

    recognizer.onerror = function(e) {
      console.log(e);
      if (onerror) {
        onerror(e);
      }
    };
  };

  init();

  var payingAttention = false;
  var isListening = false;
  var justSpoke = false;

  var speak = function(text){
    if (!text) {
      return false;
    }

    var audioURL = ['http://www.corsproxy.com/', 'translate.google.com/translate_tts?ie=UTF-8&q=', text , '&tl=', DEST_LANG].join('');
    var audio = new Audio();

    audio.addEventListener("play", function () {
      console.log('isSpeaking start');
    }, false);

    audio.addEventListener("ended", function () {
      justSpoke = true;
      console.log('isSpeaking end');
    }, false);

    audio.addEventListener("error", function () {
      console.log('error');
      console.log('isSpeaking end');
    }, false);

    audio.autoplay = true;
    audio.src = audioURL;


  };

  var random = function(from, to) {
    return Math.floor(Math.random() * (to - from + 1) + from);
  };

  var listen = function(){
    if (!isListening) {
      init();
      recognizer.start();
      console.log(recognizer);
    }
    isListening = true;
  };

  var stopListening = function(){
    if (isListening) {
      recognizer.stop();
      console.log(recognizer);
    }
    isListening = false;
  };

  var setLang = function(lang){
    DEST_LANG = lang;
    recognizer.lang = lang;
  };

  var onstart, onerror;

  var onend = function(e){
    payingAttention = false;
    recognizer = null;
  };

  var onresult = function(e){
    if (e.results.length) {
      var result = e.results[e.resultIndex];
      if (result.isFinal) {

        if (justSpoke) {
          justSpoke = false;
          return false;
        }

        var utterance = result[0].transcript.trim();

        if (payingAttention) {
          console.log(result);
          console.log('utterance: "' + utterance + '"');
          $rootScope.$broadcast('adaptive.speech:utterance', {'lang': DEST_LANG, 'utterance': utterance});
        }
      }
    }
  };

  var listenUtterance = function(tasks){
    return $rootScope.$on('adaptive.speech:utterance', function(e, data){
      var array = [];
      if (angular.isArray(tasks)) {
        array = tasks;
      }
      else {
        array.push(tasks);
      }

      array.forEach(function(command){
        console.log(data);
        console.log(command);
        if (command.lang !== DEST_LANG) {
          return false;
        }

        var regex = command.regex || null;
        var utterance = data.utterance;
        console.log(regex, utterance.match(regex));

        if (utterance.match(regex)) {
          command.call(utterance);
        }
      });
    });
  };


  return {
    onstart: function(fn){
      onstart = fn;
    },

    onerror: function(fn){
      onerror = fn;
    },

    setLang: function(lang){
      setLang(lang);
    },

    getLang: function(){
      return DEST_LANG;
    },

    speak: function(text){
      speak(text);
    },

    payAttention: function(){
      payingAttention = true;
    },

    ignore: function(){
      payingAttention = false;
    },

    listen: function(){
      listen();
    },

    stopListening: function(){
      stopListening();
    },

    listenUtterance: function(tasks){
      return listenUtterance(tasks);
    }

  };
}]);

adaptive.directive('speechrecognition', ['$rootScope', 'DEST_LANG', function ($rootScope, DEST_LANG) {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      var getOptions = function () {
        return angular.extend({}, scope.$eval(attrs.speechrecognition));
      };
      var opts = getOptions();
      console.log(opts);
      $rootScope.$on('adaptive.speech:utterance', function(e, data){

        var array = [];
        if (angular.isArray(opts.tasks)) {
          array = opts.tasks;
        }
        else {
          array.push(opts.tasks);
        }

        console.log(data);
        array.forEach(function(command){
          if (command.lang !== DEST_LANG) {
            return false;
          }

          var regex = command.regex || null;
          var utterance = data.utterance;

          if (utterance.match(regex) && utterance.match(new RegExp(opts.thing, 'ig'))) {
            console.log(regex, utterance.match(regex), utterance.match(new RegExp(opts.thing, 'ig')));
            command.call(utterance);
          }
        });
      });
    }
  };
}]);


})();
