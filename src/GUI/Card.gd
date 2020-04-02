extends Node2D

export (Texture) var card_texture = null
export (String) var title_text = ""
export (bool) var shake = false
export (float) var shake_amount = 2

var drag_mouse = false
var over_slot = false
var inserted = false
var current_slot = null
var prev_index = 0
var pos_initial
var timer = 0

func _ready():
	EventsManager.connect("level_started", self, "_on_level_started")
	
	$Area2D.connect('input_event', self, '_on_input_event')
	
	$Area2D/Sprite.texture = card_texture
	
	$Area2D/Label.set_text(title_text)
	

func _process(delta):
	if (drag_mouse):
		set_position(get_viewport().get_mouse_position())
	
	if shake:
		timer += 1
		set_position(
			pos_initial + Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount)
		)
	if timer >= 60:
		shake = false
		timer = 0
		set_position(pos_initial)


func drag_card():
	EventsManager.emit_signal('play_requested', 'Card', 'Grab')
	drag_mouse = true
	
	$Area2D/Sprite.show()
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
			EventsManager.emit_signal('play_requested', 'Card', 'Insert')
			$Area2D/Card.hide()
		else:
			current_slot = overlapping_area
			current_slot.insert_card(self)
			EventsManager.emit_signal('play_requested', 'Card', 'Insert')
			$Area2D/Card.hide()
	else:
		EventsManager.emit_signal('play_requested', 'Card', 'Drop')
		inserted = false
			
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().add_card(self)
		elif drag_mouse:
			drop_card()	

func _on_level_started():
	pos_initial = get_position()

func restart():
	drag_card()
	set_position(pos_initial)
	
	drag_mouse = false
	over_slot = false
	inserted = false
	current_slot = null
	prev_index=0
	
func dropped(target_pos: Vector2) -> void:
	set_position(target_pos)
	set_z_index(0)
	$Area2D/Sprite.hide()
