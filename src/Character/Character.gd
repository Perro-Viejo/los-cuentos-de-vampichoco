extends Node2D

var current_character = ""

func character_show(current_character):
	if current_character == "Dino":
		$Dino.show()
		$Dino.play("Idle")
	if current_character == "Paisano":
		$Paisano.show()
		$Paisano.play("Idle")
	if current_character == "Volcano":
		$Volcano.show()
		$Volcano.play("Idle")

func character_hide(current_character):
	if current_character == "Dino":
		$Dino.hide()
		$Dino.stop()
	if current_character == "Paisano":
		$Paisano.hide()
		$Paisano.stop()
	if current_character == "Volcano":
		$Volcano.hide()
		$Volcano.stop()
