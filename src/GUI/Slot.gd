extends Area2D

export (Texture) var slot_texture = null

var type = "Slot"
var current_card=null

func _ready():
	$Slot.texture = slot_texture

func _on_area_exited(card):
	remove_card(card)

func remove_card(card):
	if current_card and current_card == card:
		EventsManager.emit_signal("card_removed", get_name(), current_card.get_name())
		current_card=null
		
func insert_card(card):
	if !current_card || card == current_card:
		current_card = card
		card.dropped(get_position())
		EventsManager.emit_signal("card_inserted", get_name(), current_card.get_name())

func restart():
	current_card=null;
