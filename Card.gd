extends Node2D

var dragMouse = false
var overSlot = false
var slotPos
export (Texture) var card_texture = null

func _ready():
	$Area2D.connect('input_event', self, '_on_input_event')
	$Area2D.connect('area_entered', self, '_on_area_entered')
	$Area2D.connect('area_exited', self, '_on_area_exited')
	
	$Area2D/Sprite.texture = card_texture

func _process(delta):
	if (dragMouse):
		set_position(get_viewport().get_mouse_position())

func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			dragMouse = true
		else:
			dragMouse = false
			if overSlot:
				set_position(slotPos)

func _on_area_entered(other):
	if "type" in other:
		if other.type == 'Slot':
			overSlot = true
			slotPos = other.get_position()

func _on_area_exited(other):
	if "type" in other:
		if other.type == 'Slot':
			overSlot = false
	
