
var start = document.getElementById('start');
var reset = document.getElementById('reset');

var h = document.getElementById("hour");
var m = document.getElementById("minute");
var s = document.getElementById("sec");

var topicBox = document.getElementById("topics");

var calcQuizzLink = document.getElementById('calcQuizzLink');
var calcQuizzURL = calcQuizzLink.getAttribute('data-url');

var algQuizzLink = document.getElementById('algQuizzLink');
var algQuizzURL = algQuizzLink.getAttribute('data-url');

var trigQuizzLink = document.getElementById('trigQuizzLink');
var trigQuizzURL = trigQuizzLink.getAttribute('data-url');


//store a reference to the startTimer variable
var startTimer = null;

start.addEventListener('click', function(){
    //initialize the variable
    function startInterval(){
        startTimer = setInterval(function() {
            timer();
        }, 1000);
    }
    startInterval();
})

reset.addEventListener('click', function(){
    h.value = 0;
    m.value = 0;
    s.value = 0;
    //stop the timer after pressing "reset"
    stopInterval()
})
function directToCalcQuizz(){
    window.location.href = calcQuizzURL;
}
function directToAlgQuizz(){
    window.location.href = algQuizzURL;
}
function directToTrigQuizz(){
    window.location.href = trigQuizzURL;
}

function timer(){
    if(h.value == 0 && m.value == 0 && s.value == 0){
        h.value = 0;
        m.value = 0;
        s.value = 0;
        if (topicBox.options[topicBox.selectedIndex].text == "Calculus"){
            directToCalcQuizz()
        }
        if (topicBox.options[topicBox.selectedIndex].text == "Algebra"){
            directToAlgQuizz()
        }
        if (topicBox.options[topicBox.selectedIndex].text == "Trigonometry"){
            directToTrigQuizz()
        }
        h.value = 0;
        m.value = 0;
        s.value = 0;
        stopInterval()
        // const audio = new Audio("error-when-entering-the-game-menu-132111.mp3");
        // audio.play();
    } else if(s.value != 0){
        s.value--;
    } else if(m.value != 0 && s.value == 0){
        s.value = 59;
        m.value--;
    } else if(h.value != 0 && m.value == 0){
        m.value = 60;
        h.value--;
    }
    return;
}



//stop the function after pressing the reset button, 
//so the time wont go down when selecting a new time after pressing reset
function stopInterval() {
    clearInterval(startTimer);
}