extends Node2D
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Variables ▒▒▒▒
var inserted_cards = 0
var slot_order = ['Empty','Empty','Empty',]
# privates
var _story: String = ''
# on ready
onready var _dflt_pos: Dictionary = {
	a = $GUI/Control/SlotA.position,
	b = $GUI/Control/SlotB.position,
	c = $GUI/Control/SlotC.position,
	boat = $frame/Boat.position
}
onready var lavas: Node2D = $frame/Lavas
onready var impacts: Node2D = $frame/Impacts
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Funciones ▒▒▒▒
func _ready():
	# Poner posiciones por defecto
	_set_dflt_positions()
	
	EventsManager.emit_signal('play_requested', 'BG', 'Level1')
	EventsManager.connect('card_inserted', self, '_on_card_inserted')
	EventsManager.connect('card_removed', self, '_on_card_removed')


func _on_card_inserted(Slot, Character):
	inserted_cards += 1
	if Slot == "SlotA":
		slot_order.remove(0)
		slot_order.insert(0, Character)
		$CharacterA.character_show(Character)
	if Slot == "SlotB":
		slot_order.remove(1)
		slot_order.insert(1, Character)
		$CharacterB.character_show(Character)
		
	if Slot == "SlotC":
		slot_order.remove(2)
		slot_order.insert(2, Character)
		$CharacterC.character_show(Character)
	if inserted_cards == 3:
		storyboard_complete()


func _on_card_removed(Slot, Character):
	inserted_cards -= 1
	if Slot == "SlotA":
		slot_order.remove(0)
		slot_order.insert(0, 'Empty')
		$CharacterA.character_hide(Character)
	if Slot == "SlotB":
		slot_order.remove(1)
		slot_order.insert(1, 'Empty')
		$CharacterB.character_hide(Character)
	if Slot == "SlotC":
		slot_order.remove(2)
		slot_order.insert(2, 'Empty')
		$CharacterC.character_hide(Character)
	$Final.set_text('')


func storyboard_complete():
	yield(get_tree().create_timer(2.4), "timeout")
	EventsManager.emit_signal('storyboard_completed')
	
	var final_num: int = 0
	var final_text: String = 'Final #%s'

	match slot_order:
		['Volcano','Dino','Paisano']:
			final_num = 1
		['Volcano','Paisano','Dino']:
			final_num = 2
		['Dino','Volcano','Paisano']:
			final_num = 3
		['Paisano','Volcano','Dino']:
			final_num = 4
		['Dino','Paisano','Volcano']:
			final_num = 5
		['Paisano','Dino','Volcano']:
			final_num = 6

	_story = 'Final_0%d' % final_num
	
	$EndingAnimations.play(_story)
	yield($EndingAnimations, 'animation_finished')

	$Final.set_text(final_text % final_num)
	$Final.show()
	
	if final_num != 6:
		restart()
	else:
		end_level()

func restart():
	yield(get_tree().create_timer(5.0), 'timeout')

	$GUI.get_node("Control").restart()

	EventsManager.emit_signal('play_requested', "Card", 'Reset')
	
	inserted_cards = 0
	slot_order = ['Empty','Empty','Empty',]

	$CharacterA.restart()
	$CharacterB.restart()
	$CharacterC.restart()
	$Final.set_text('')
	$Final.hide()
	
	# Reestablecer cosas del escenario
	$frame/Boat.play('Stay')
	for impact in impacts.get_children(): impact.hide()
	for lava in lavas.get_children(): lava.rotation_degrees = 0

	_set_dflt_positions()

func end_level():
	$GUI/Menu.show()
	$GUI/Menu/AnimationPlayer.play('End')
	$GUI/Menu/AnimationPlayer.playback_speed = 1.0
	yield(get_tree().create_timer(5), "timeout")
	EventsManager.emit_signal('play_requested', 'VO', 'End')
	EventsManager.emit_signal('stop_requested', 'Dino', 'Dance')
	EventsManager.emit_signal('stop_requested', 'Volcano', 'Dance')
	$GUI/Menu.finish_level()


func play_vo() -> void:
	EventsManager.emit_signal('play_requested', "Final", _story)


func pause_vo() -> void:
	EventsManager.emit_signal('pause_requested', "Final", _story)


func _set_dflt_positions() -> void:
	$CharacterA.position = _dflt_pos.a
	$CharacterB.position = _dflt_pos.b
	$CharacterC.position = _dflt_pos.c
	$frame/Boat.position = _dflt_pos.boat


func _get_character(letter: String) -> Node2D:
	return get_node('Character%s' % letter.to_upper()) as Node2D


func spit_lava(src: String) -> void:
	var character: Node2D = _get_character(src)

	for lava in lavas.get_children():
		lava.global_position = character.global_position
		lava.position.y -= 16

		$Tween.interpolate_property(
			lava,
			'position:y',
			lava.position.y,
			lava.position.y - 560,
			0.5,
			Tween.TRANS_SINE,
			Tween.EASE_OUT
		)
		$Tween.start()
		lava.show()

		yield(get_tree().create_timer(0.5), 'timeout')


func _show_mark(target: Node2D, key: NodePath, idx: int) -> void:
	$Tween.disconnect('tween_completed', self, '_show_mark')

	var impact: Sprite = impacts.get_child(idx)

	impact.global_position = target.global_position
	impact.position.y += 48
	
	# AUDIO: Aquí se puede reproducir en SFX de las bolas impactando
	
	impact.show()
	target.hide()


func fall_lava(targetA: String, targetB: String, wait: float = 0.0) -> void:
	lavas.get_child(0).global_position.x = _get_character(targetA).global_position.x
	lavas.get_child(1).global_position.x = _get_character(targetB).global_position.x
	
	var idx: int = 0
	for lava in lavas.get_children():
		lava.rotation_degrees = 180

		if not $Tween.is_connected('tween_completed', self, '_show_mark'):
			$Tween.connect('tween_completed', self, '_show_mark', [ idx ])

		$Tween.interpolate_property(
			lava,
			'position:y',
			lava.position.y,
			lava.position.y + 560,
			0.7,
			Tween.TRANS_SINE,
			Tween.EASE_IN
		)
		$Tween.start()
		# AUDIO: Aquí se puede reproducir en SFX de las bolas cayendo

		yield(get_tree().create_timer(wait), 'timeout')

		idx += 1
