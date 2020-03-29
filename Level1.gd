extends Node2D

func _ready():
	EventsManager.connect('card_inserted', self, '_on_card_inserted')
	EventsManager.connect('card_removed', self, '_on_card_removed')
	
func _on_card_inserted(Slot, Character):
	print(Slot, Character)
	if Slot == "SlotA":
		$CharacterA.character_show(Character)
	if Slot == "SlotB":
		$CharacterB.character_show(Character)
	if Slot == "SlotC":
		$CharacterC.character_show(Character)
func _on_card_removed(Slot, Character):
	print(Slot, Character)
	if Slot == "SlotA":
		$CharacterA.character_hide(Character)
	if Slot == "SlotB":
		$CharacterB.character_hide(Character)
	if Slot == "SlotC":
		$CharacterC.character_hide(Character)
