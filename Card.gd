extends Node2D

export (Texture) var card_texture = null
export (String) var title_text = ""

var dragMouse = false
var overSlot = false
var slotPos
var current_slot = null

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
			if get_z_index() < 3:
				set_z_index(3)
				dragMouse = true
		else:
			dragMouse = false
			if overSlot:
				if current_slot.empty:
					set_position(slotPos)
					current_slot.empty = false

func _on_area_entered(other):
	print(other.get_parent().get_name())
	if "type" in other:
		if other.type == 'Slot':
			current_slot = other
			overSlot = true
			slotPos = other.get_position()

func _on_area_exited(other):
	if "type" in other:
		if other.type == 'Slot':
			overSlot = false
	
