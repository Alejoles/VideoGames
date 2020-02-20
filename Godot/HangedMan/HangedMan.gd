extends Control

var word = "physics h"
var guess = ""
var Tries = 9

onready var guessWord = get_node("VBoxContainer/guessWord")
onready var numTries = get_node("VBoxContainer/HBoxContainer2/numTries")
onready var ResetLabel = get_node("VBoxContainer/HBoxContainer2/ResetLabel")
onready var inputBox = get_node("VBoxContainer/HBoxContainer2/inputBox")
onready var Area2ds = get_node("VBoxContainer/Area2D/Sprite")
onready var GameStatus = get_node("VBoxContainer/GameStatus")

var stage = [
	preload("res://assets/assets/stage0.png"),
	preload("res://assets/assets/stage1.png"),
	preload("res://assets/assets/stage2.png"),
	preload("res://assets/assets/stage3.png"),
	preload("res://assets/assets/stage4.png"),
	preload("res://assets/assets/stage5.png"),
	preload("res://assets/assets/stage6.png"),
	preload("res://assets/assets/stage7.png"),
	preload("res://assets/assets/stage8.png"),
	preload("res://assets/assets/stage9.png")
	]




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
		guessWord.text = guess
		print(str(guessWord.text))
		verify_win(word)
	else:
		Tries = verify_lose(Tries)
		numTries.text = "Intentos restantes:" + str(Tries)
	inputBox.clear()



func _ready():
	guess = numLines(word);
	guessWord.text = guess
	numTries.text = "Intentos restantes: 9"
	ResetLabel.text = "Reset"
	print(guess)

# Verifica cuando el usuario gana
func verify_win(word):
	if(word == guessWord.text):
		var text = "You win"
		GameOver(text)

#Verifica cuando el jugador va perdiendo turnos
func verify_lose(Tries):
	Tries = Tries-1
	var num = 9-Tries
	var strpath = "res://assets/assets/stage"+str(num)+".png"
	var path = load(strpath)
	var Draw = Area2ds
	Draw.set_texture(path)
	if(Tries == 0):
		GameOver("You loose")
	return Tries



func GameOver(text):
	inputBox.queue_free()
	GameStatus.text = text


# Función que me hace reset del programa
func _on_TextureButton_pressed():
	get_tree().reload_current_scene()











