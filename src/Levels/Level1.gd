extends Node2D

var inserted_cards = 0
var slot_order = ['Empty','Empty','Empty',]

func _ready():
	EventsManager.emit_signal('play_requested', 'BG', 'Level1')
	EventsManager.connect('card_inserted', self, '_on_card_inserted')
	EventsManager.connect('card_removed', self, '_on_card_removed')
	
func _on_card_inserted(Slot, Character):
	
	EventsManager.emit_signal('play_requested', Character, 'Show')
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
	match slot_order:
		['Volcano','Dino','Paisano']:
			EventsManager.emit_signal('play_requested', 'Volcano', 'Explode')
			EventsManager.emit_signal('play_requested', 'Paisano', 'Walk')
			EventsManager.emit_signal('play_requested', 'Dino', 'Scream')
			yield(play_anims('Erupt', 'Run', 'Walk'), 'completed')
			
			$Final.set_text('Final #1')
			EventsManager.emit_signal('play_requested', "Final", 'Final_01')
			restart()
		['Volcano','Paisano','Dino']:
			EventsManager.emit_signal('play_requested', 'Volcano', 'Explode')
			EventsManager.emit_signal('play_requested', 'Paisano', 'Show')
			EventsManager.emit_signal('play_requested', 'Dino', 'Scream')
			yield(play_anims('Erupt', 'Idle', 'Run'), 'completed')
			
			$Final.set_text('Final #2')
			EventsManager.emit_signal('play_requested', "Final", 'Final_02')
			restart()
		['Dino','Volcano','Paisano']:
			EventsManager.emit_signal('play_requested', 'Paisano', 'Burn')
			EventsManager.emit_signal('play_requested', 'Volcano', 'Explode')
			EventsManager.emit_signal('play_requested', 'Dino', 'Sleep')
			$Fire.set_position($CharacterA.position)
			$Fire.play('Burn')
			$Fire.show()
			yield(play_anims('Sleep', 'Erupt', 'Idle'), 'completed')
			
			$Final.set_text('Final #3')
			EventsManager.emit_signal('play_requested', "Final", 'Final_03')
			restart()
		['Paisano','Volcano','Dino']:
			EventsManager.emit_signal('play_requested', 'Paisano', 'Climb')
			EventsManager.emit_signal('play_requested', 'Volcano', 'Explode')
			EventsManager.emit_signal('play_requested', 'Dino', 'Scream')
			$Fire.set_position($CharacterA.position)
			$Fire.play('Burn')
			$Fire.show()
			yield(play_anims('Climb', 'Erupt', 'Run'), 'completed')
			
			$Final.set_text('Final #4')
			EventsManager.emit_signal('play_requested', "Final", 'Final_04')
			restart()
		['Dino','Paisano','Volcano']:
			EventsManager.emit_signal('play_requested', 'Volcano', 'Dance')
			EventsManager.emit_signal('play_requested', 'Dino', 'Eat')
			yield(play_anims('Eat', 'Dance', 'Dance'), 'completed')
			
			$Final.set_text('Final #5')
			EventsManager.emit_signal('play_requested', "Final", 'Final_05')
			restart()
		['Paisano','Dino','Volcano']:
			EventsManager.emit_signal('play_requested', 'Volcano', 'Dance')
			EventsManager.emit_signal('play_requested', 'Dino', 'Dance')
			yield(play_anims('Dance', 'Dance', 'Dance'), 'completed')
			
			$Final.set_text('Final #6')
			EventsManager.emit_signal('play_requested', "Final", 'Final_06')

func restart():
	yield(get_tree().create_timer(5.0), 'timeout')
	
	$GUI.get_node("Control").restart()
	inserted_cards = 0
	slot_order = ['Empty','Empty','Empty',]
	$CharacterA.restart()
	$CharacterB.restart()
	$CharacterC.restart()
	
	$Fire.stop()
	$Fire.hide()


func play_anims(id_a: String, id_b: String, id_c: String) -> void:
	$CharacterA.play_anim(id_a)
	$CharacterB.play_anim(id_b)
	$CharacterC.play_anim(id_c)
	yield(get_tree().create_timer(10), 'timeout')
