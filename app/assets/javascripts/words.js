if ( typeof (word) == typeof (undefined)) {
  word = {};
}

word = {
  stage: {
    up: 0,
    fixed: 0,
    down: 0
  },
  round: 1,
  index: 0,
  prevCorde: 0,
  remainningWordSize: 0,
  currentSequence: 0,
  wordList: [],
  init: function() {
    this.round = 1;
    this.index = 0;
    this.stage = {
      up: 0,
      fixed: 0,
      down: 0
    };
    this.wordList = [];
    this.getWordList();
    this.addEventListener();
    this.addUpdateWordListEventListener();
    $('#word_word').focus();
    this.remainningWordSize = $('#remainning-word-size').text() - 0;
    this.currentSequence = 1;
  },
  getWordList: function() {
    var wordRows = $('[data-word-row]'),
        $row;
    for(var i = 0, wordRowsLength = wordRows.length ; i < wordRowsLength ; i++) {
      $row = wordRows.eq(i);
      this.wordList[i] = {
        id: $row.data('word-id'),
        stage: $row.data('stage'),
        isPass: false
      };
    }
  },
  addEventListener: function() {
    this.addAnswerEventListener();
    this.addNextEventListener();
    this.addCheckEventListener();
    this.addHotkeyEventListener();
  },
  addHotkeyEventListener : function() {
    $('#word_meaning').on('keyup', function(e) {
      var code = e.keyCode || e.which;
      if(code == 32 && word.prevCorde == 32) {// 1
        e.preventDefault();
        var prevValue = $(this).val();
        $(this).val(prevValue.substr(0, prevValue.length - 1) + '/ ');
        word.prevCorde = 0;
      } else {
        word.prevCorde = code;
      }
    });

    $('#word_word').on('keyup', function(e) {
      var code = e.keyCode || e.which;
      if(code == 32 && word.prevCorde == 32) {// 1
        $('#word_meaning').focus();
        var prevValue = $(this).val();
        $(this).val(prevValue.substr(0, prevValue.length - 2));
        word.prevCorde = 0;
      } else {
        word.prevCorde = code;
      }
    });
  },
  addAnswerEventListener: function() {
    var showNextController = function() {
      $('#answer-controller').hide();
      $('#next-controller').show();
    };

    var showCheckController = function() {
      $('#answer-controller').hide();
      $('#check-controller').show();
    };

    var knowOrConfusingWordMeanEvent = function() {
      showCheckController();
      $('[data-word-row]').eq(word.index).children('[data-meaning]').removeClass('hidden');
    };

    var dontKnowWordMeanEvent = function() {
      showNextController();
      if(word.round == 3) {
        word.stage.down += 1;
        word.wordList[word.index].stage = 0;
      }
      $('[data-word-row]').eq(word.index).children('[data-meaning]').removeClass('hidden');
    };

    $('#know-btn').on('click', function() {
      knowOrConfusingWordMeanEvent();
    });

    $('#confusing-btn').on('click', function() {
      knowOrConfusingWordMeanEvent();
    });

    $('#dont-know-btn').on('click', function() {
      dontKnowWordMeanEvent();
    });


  },
  addNextEventListener: function() {
    $('#next-btn').on('click', function() {
      $('#next-controller').hide();
      $('[data-word-row]').eq(word.index).children('[data-meaning]').addClass('hidden');
      word.showNextAnswer();
    });
  },
  addCheckEventListener: function() {
    var showNextAnswer = word.showNextAnswer;

    $('#correct-btn').on('click', function() {
      $('#check-controller').hide();
      word.remainningWordSize--;
      switch(word.round) {
      case 1:
        word.wordList[word.index].stage += 1;
        if( word.wordList[word.index].stage == 8 ) {
          word.wordList[word.index].stage = 7;
        }
        word.stage.up += 1;

        break;
      case 2:
      case 3:
        word.stage.fixed += 1;
        break
      default:
        break;
      }
      word.wordList[word.index].isPass = true;
      showNextAnswer();
    });

    $('#wrong-btn').on('click', function() {
      $('#check-controller').hide();
      if(word.round == 3) {
        word.stage.down += 1;
        word.wordList[word.index].stage = 0;
      }
      $('[data-word-row]').eq(word.index).children('[data-meaning]').addClass('hidden');
      showNextAnswer();
    });
  },
  addUpdateWordListEventListener: function() {
    $('[data-update-word-list-btn]').on('click', function() {
      word.request();
    });
  },

  showNextAnswer: function() {
    var wordList = word.wordList,
        $wordRow = $('[data-word-row]');

    $wordRow.eq(word.index).hide();
    do {
      word.index = word.index + 1;

      if(wordList.length == word.index) {
        word.round = word.round + 1;
        word.index = 0;
        word.currentSequence = 0;
        $('#remainning-word-size').text(word.remainningWordSize);
      }
    }while(wordList[word.index].isPass && word.round != 4);

    if (word.round == 4) {
      $('#question').hide();
      $('#question-size').text(wordList.length);
      $('#stage-up-size').text(word.stage.up);
      $('#stage-fixed-size').text(word.stage.fixed);
      $('#stage-down-size').text(word.stage.down);


      $('#result').show();
    } else {
      
      $('#answer-controller').show();
      $wordRow.eq(word.index).show();  
    }
    $('#current-word-index').text(++word.currentSequence);
  },

  request: function() {
    $.ajax({
      type: "PUT",
      url: "/words/mutipule_update",
      data: { word_lst: word.wordList }
    }).success(function(result){
      $(location).attr('href','/folders');
    });
  }
}

$(document).on('ready page:load', function() {
  $('[data-word-row]:eq(0)').show();
  word.init();
}); 