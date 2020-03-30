extends Node2D

var inserted_cards = 0
var slot_order = ['Empty','Empty','Empty',]

func _ready():
	EventsManager.connect('card_inserted', self, '_on_card_inserted')
	EventsManager.connect('card_removed', self, '_on_card_removed')
	
func _on_card_inserted(Slot, Character):
	inserted_cards += 1
	if Slot == "SlotA":
		slot_order.remove(0)
		slot_order.insert(0, Character)
		$CharacterA.character_show(Character)
		EventsManager.emit_signal('play_requested', Character, 'SlotA')
	if Slot == "SlotB":
		slot_order.remove(1)
		slot_order.insert(1, Character)
		$CharacterB.character_show(Character)
		EventsManager.emit_signal('play_requested', Character, 'SlotB')
		
	if Slot == "SlotC":
		slot_order.remove(2)
		slot_order.insert(2, Character)
		$CharacterC.character_show(Character)
		EventsManager.emit_signal('play_requested', Character, 'SlotC')
		
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
			$Final.set_text('Final #1')
			EventsManager.emit_signal('play_requested', "Final", 'Final_01')
			restart()
		['Volcano','Paisano','Dino']:
			$Final.set_text('Final #2')
			EventsManager.emit_signal('play_requested', "Final", 'Final_02')
			restart()
		['Dino','Volcano','Paisano']:
			$Final.set_text('Final #3')
			EventsManager.emit_signal('play_requested', "Final", 'Final_03')
			restart()
		['Paisano','Volcano','Dino']:
			$Final.set_text('Final #4')
			EventsManager.emit_signal('play_requested', "Final", 'Final_04')
			restart()
		['Dino','Paisano','Volcano']:
			$Final.set_text('Final #5')
			EventsManager.emit_signal('play_requested', "Final", 'Final_05')
			restart()
		['Paisano','Dino','Volcano']:
			$Final.set_text('Final #6')
			EventsManager.emit_signal('play_requested', "Final", 'Final_06')

func restart():
	$GUI.get_node("Control").restart()
	inserted_cards = 0
	slot_order = ['Empty','Empty','Empty',]
	$CharacterA.restart()
	$CharacterB.restart()
	$CharacterC.restart()
