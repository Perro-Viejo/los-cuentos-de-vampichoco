extends Area2D

export (Texture) var slot_texture = null

var type = "Slot"
var empty = true
var current_card


func _ready():
	connect('area_entered', self, '_on_area_entered')
	connect('area_exited', self, '_on_area_exited')
	
	$Slot.texture = slot_texture

func _on_area_entered(other):
	if empty:
		print('jesus entro en mi')
		current_card = other.get_parent()

func _on_area_exited(other):
	if not empty:
		if other.get_parent() == current_card:
			empty = true
			$Slot.show()
			EventsManager.emit_signal("card_removed", get_name(), current_card.get_name())
			print("salio ", current_card.get_name())

func insert_card():
	EventsManager.emit_signal("card_inserted", get_name(), current_card.get_name())
	if empty:
		print("inserte", current_card.get_name())
		$Slot.hide()
		current_card.set_position(get_position())
		current_card.set_z_index(0)
		empty = false

