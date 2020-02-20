extends Control

var word = "physics h"
var guess = ""

var numTries = 9

func numLines(word):
	for i in word:
		if(i != " "):
			guess = guess + "_"
		else:
			guess = guess + " "
	return guess

func _on_inputBox_text_entered(text):
	if(text in word):
		print("True")
		for i in range(0,word.length()):
			if(word[i] == text):
				guess[i] = text
		get_node("guessWord").text = guess
		print(get_node("guessWord").text)
		verify_win(word)
	else:
		numTries = verify_lose(numTries)
		get_node("numTries").text = "Intentos restantes:" + str(numTries)
	get_node("inputBox").clear()



func _ready():
	guess = numLines(word);
	get_node("guessWord").text = guess
	get_node("numTries").text = "Intentos restantes: 9"
	get_node("ResetLabel").text = "Reset"
	print(guess)

# Verifica cuando el usuario gana
func verify_win(word):
	if(word == get_node("guessWord").text):
		var text = "You win"
		GameOver(text)

#Verifica cuando el jugador va perdiendo turnos
func verify_lose(numTries):
	numTries = numTries-1
	var num = 9-numTries
	var strpath = "res://assets/assets/stage"+str(num)+".png"
	var path = load(strpath)
	var Draw = get_node("Area2D/Sprite")
	Draw.set_texture(path)
	if(numTries == 0):
		GameOver("You loose")
	return numTries



func GameOver(text):
	get_node("inputBox").queue_free()
	get_node("GameStatus").text = text


# Función que me hace reset del programa
func _on_TextureButton_pressed():
	get_tree().reload_current_scene()











