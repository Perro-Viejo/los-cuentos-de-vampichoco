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
	
	$Area2D/Sprite.texture = card_texture
	$Area2D/Label.set_text(title_text)

func _process(delta):
	if (drag_mouse):
		set_position(get_viewport().get_mouse_position())

func drag_card():
	drag_mouse = true
	if not $Area2D/Card.visible:
		$Area2D/Card.show()
	
	if current_slot:
		current_slot.remove_card(self)
		
func drop_card():
	drag_mouse = false;
	get_parent().remove_card()
	
	var overlapping_area = null
	
	for oa in $Area2D.get_overlapping_areas():
		if "Slot" in oa.name:
			if !oa.current_card || oa.current_card == self:
				overlapping_area = oa
				break
	
	if overlapping_area:
		if not inserted:
			inserted=true
			
		if current_slot != overlapping_area:
			current_slot = overlapping_area
			current_slot.insert_card(self)
			$Area2D/Card.hide()
		else:
			current_slot = overlapping_area
			current_slot.insert_card(self)
			$Area2D/Card.hide()
	else:
		inserted = false
			
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().add_card(self)
		elif drag_mouse:
			drop_card()	
