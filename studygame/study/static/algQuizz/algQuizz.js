// Define the questions and answers in a two-dimensional array
const quiz = [

    [ 
"Solve for x: 2x + 5 = 11.",
"x = 3"
],
[
"Simplify 2x - 3y + 4x + 5y",
"6x + 2y"
],
[
"Factor the expression: 2x^2 + 8x + 6.",
"2(x + 1)(x + 3)"
],
[
"Solve the system of equations: x - y = 3, x + y = 7",
" x = 5, y = 2"
],
[
"Solve for x: 3x^2 - 7x + 2 = 0.",
"x = 1/3 or x = 2/3"
],
[
"Simplify the expression: (2x + 5) / (x + 3).",
"2 - (1 / (x + 3))"
],
[
"Solve the inequality: 2x + 1 > 5x - 3.",
"x < 2"
],
[
"Solve for x: log(base 3) x = 4.",
"x = 81"
],
[
"Simplify the expression: √(48x^2y^4).",
"4xy^2(sqrt(3))"
],
[
"Solve the system of equations: 2x - 3y = -5, 4x + 5y = 23",
"x = 4, y = 3"
]
];


let currentQuestionIndex = Math.floor(Math.random() * quiz.length);

// Display the current question on the page
function displayQuestion() {
    const question = quiz[currentQuestionIndex][0];
    const answer = quiz[currentQuestionIndex][1];
    document.getElementById("question").innerHTML = question;
    document.getElementById("answer").value = "";
    document.getElementById("result").innerHTML = "";
}
displayQuestion();

// Check if the user's answer matches the correct answer
function checkAnswer() {
    const userAnswer = document.getElementById("answer").value;
    const resultDiv = document.getElementById("result");
    if (userAnswer.toLowerCase() === quiz[currentQuestionIndex][1].toLowerCase()) {
        resultDiv.innerHTML = "<p class='correct'>Correct!</p>";
    } else {
        resultDiv.innerHTML = "<p class='incorrect'>Incorrect. The correct answer is " + quiz[currentQuestionIndex][1] + "</p>";
    }
    currentQuestionIndex = (currentQuestionIndex + 1) % quiz.length;
    setTimeout(displayQuestion, 10000);
}