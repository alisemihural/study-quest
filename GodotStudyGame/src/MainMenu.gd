extends Control

func _ready():
	# Create a logo texture and assign it to the logo texture property
	var logoTexture = preload("res://logo1.png")
	$LogoTexture.texture = logoTexture

	# Connect the button's "pressed" signal to a function
	$PlayButton.connect("pressed", self, "_on_PlayButton_pressed")

func _on_PlayButton_pressed():
	# Replace this with the code you want to execute when the button is pressed
	get_tree().change_scene("res://src/world1.tscn")
