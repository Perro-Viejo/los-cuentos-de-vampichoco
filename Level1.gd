extends Node2D

var inserted_cards = 0

func _ready():
	EventsManager.connect('card_inserted', self, '_on_card_inserted')
	EventsManager.connect('card_removed', self, '_on_card_removed')
	
func _on_card_inserted(Slot, Character):
	inserted_cards += 1
	if Slot == "SlotA":
		$CharacterA.character_show(Character)
	if Slot == "SlotB":
		$CharacterB.character_show(Character)
	if Slot == "SlotC":
		$CharacterC.character_show(Character)
	
	if inserted_cards == 3:
		storyboard_complete()
func _on_card_removed(Slot, Character):
	inserted_cards -= 1
	if Slot == "SlotA":
		$CharacterA.character_hide(Character)
	if Slot == "SlotB":
		$CharacterB.character_hide(Character)
	if Slot == "SlotC":
		$CharacterC.character_hide(Character)

func storyboard_complete():
	print("Estan todos los tarjetos")
