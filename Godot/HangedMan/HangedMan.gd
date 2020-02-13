extends Control

var word = "physics"
var guess = ""

var numTries = 9

func numLines(word):
	for i in word:
		guess = guess + "_"
	return guess

func _on_inputBox_text_entered(text):
	if(text in word):
		print("True")
		for i in range(0,word.length()):
			if(word[i] == text):
				guess[i] = text
		get_node("guessWord").text = guess
	else:
		print("False")
	get_node("inputBox").clear()



func _ready():
	guess = numLines(word);
	get_node("guessWord").text = guess
	print(guess)



