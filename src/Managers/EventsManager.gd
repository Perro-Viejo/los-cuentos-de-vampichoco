extends Node

#----------SlotsBehaviour----------
signal card_inserted(Slot, Card)
signal card_removed(Slot, Card)
signal storyboard_completed()

#----------AudioManager------------
signal play_requested(source, sound)
signal stop_requested(source, sound)
signal pause_requested(source, sound)

#----------Animation--------------
signal level_started()
