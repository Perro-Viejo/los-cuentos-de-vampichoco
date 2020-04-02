extends Node2D

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
	$frame/Boat.play('Stay')

	_set_dflt_positions()

func end_level():
	$GUI/Menu.show()
	$GUI/Menu/AnimationPlayer.play('End')
	yield(get_tree().create_timer(5), "timeout")
	EventsManager.emit_signal('play_requested', 'VO', 'End')
	EventsManager.emit_signal('stop_requested', 'Dino', 'Dance')
	EventsManager.emit_signal('stop_requested', 'Volcano', 'Dance')
	yield($GUI/Menu/AnimationPlayer, 'animation_finished')
	$GUI/Menu.level_finished = true
	yield(get_tree().create_timer(2), "timeout")
	$GUI/Menu/End/Label3.show()
	$GUI/Menu/Button.show()
	
	
func play_vo() -> void:
	EventsManager.emit_signal('play_requested', "Final", _story)


func pause_vo() -> void:
	EventsManager.emit_signal('pause_requested', "Final", _story)


func _set_dflt_positions() -> void:
	$CharacterA.position = _dflt_pos.a
	$CharacterB.position = _dflt_pos.b
	$CharacterC.position = _dflt_pos.c
	$frame/Boat.position = _dflt_pos.boat
