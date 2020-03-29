extends Area2D

export (Texture) var slot_texture = null

var type = "Slot"
var empty = true

func _ready():
	$Slot.texture = slot_texture

