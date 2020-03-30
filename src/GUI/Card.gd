extends Node2D

export (Texture) var card_texture = null
export (String) var title_text = ""

var drag_mouse = false
var over_slot = false
var inserted = false
var current_slot = null
var slot_pos
var prev_index=0
func _ready():
	$Area2D.connect('input_event', self, '_on_input_event')
	$Area2D.connect('area_entered', self, '_on_area_entered')
	$Area2D.connect('area_exited', self, '_on_area_exited')
	
	$Area2D/Sprite.texture = card_texture
	$Area2D/Label.set_text(title_text)

func _process(delta):
	if (drag_mouse):
		set_position(get_viewport().get_mouse_position())

func drag_card():
	drag_mouse = true
	if not $Area2D/Card.visible:
		$Area2D/Card.show()
		
func drop_card():
	drag_mouse = false;
	get_parent().remove_card()
	if over_slot:
		if not inserted:
			current_slot.insert_card()
			$Area2D/Card.hide()
			inserted = true
		else:
			set_position(current_slot.get_position())
			$Area2D/Card.hide()
			
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().add_card(self)
		else:
			drop_card()

func _on_area_entered(other):
	if "type" in other:
		if other.type == 'Slot':
			current_slot = other
			over_slot = true
			
func _on_area_exited(other):
	if "type" in other:
		if other.type == 'Slot':
			over_slot = false
		if inserted:
			inserted = false
	
