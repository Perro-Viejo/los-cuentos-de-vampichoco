extends Node2D

export (Texture) var card_texture = null
export (String) var title_text = ""

var dragMouse = false
var overSlot = false
var inserted = false
var current_slot = null
var slotPos

func _ready():
	$Area2D.connect('input_event', self, '_on_input_event')
	$Area2D.connect('area_entered', self, '_on_area_entered')
	$Area2D.connect('area_exited', self, '_on_area_exited')
	
	$Area2D/Sprite.texture = card_texture
	$Area2D/Label.set_text(title_text)

func _process(delta):
	if (dragMouse):
		set_position(get_viewport().get_mouse_position())

func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			dragMouse = true
			if not $Area2D/Card.visible:
				$Area2D/Card.show()
			
		else:
			dragMouse = false
			if overSlot:
				if not inserted:
					current_slot.insert_card()
					$Area2D/Card.hide()
					inserted = true
				else:
					set_position(current_slot.get_position())
					$Area2D/Card.hide()

func _on_area_entered(other):
	if "type" in other:
		if other.type == 'Slot':
			current_slot = other
			overSlot = true
func _on_area_exited(other):
	if "type" in other:
		if other.type == 'Slot':
			overSlot = false
		if inserted:
			inserted = false
	
