class_name GUI
extends Control
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Variables ▒▒▒▒
var dragging_card=false;
var dragged_card=null;
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Funciones ▒▒▒▒
func _ready():
	$Dino.prev_index = 1
	$Dino.z_index = 1
	
	$Paisano.prev_index = 2
	$Paisano.z_index = 2
	
	$Volcano.prev_index = 3
	$Volcano.z_index = 3
	
	# Conectar escuchadores de señales
	EventsManager.connect('storyboard_completed', self, 'toggle_slots', [ false ])

func add_card(card_to_add):
	if dragged_card == null:
		card_to_add.prev_index = card_to_add.z_index
		dragged_card = card_to_add
		dragged_card.drag_card()
		set_indexes_accordingly(dragged_card)
	else:
		if card_to_add.prev_index > dragged_card.prev_index:
			dragged_card.drag_mouse=false
			remove_card()
			dragged_card = card_to_add
			dragged_card.drag_card()
			set_indexes_accordingly(dragged_card)	

func remove_card():
	dragged_card=null
	$Paisano.prev_index = $Paisano.z_index
	$Volcano.prev_index = $Volcano.z_index
	$Dino.prev_index = $Dino.z_index
	
func set_index(card, index):
	if index != 3:
		if card.z_index == 3:
			card.z_index = index
		
func set_indexes_accordingly(card):
	match card.name:
		"Dino":
			set_index($Paisano, $Dino.z_index)
			set_index($Volcano, $Dino.z_index)
			$Dino.z_index = 3
		"Paisano":
			set_index($Dino, $Paisano.z_index)
			set_index($Volcano, $Paisano.z_index)
			$Paisano.z_index = 3
		"Volcano":
			set_index($Paisano, $Volcano.z_index)
			set_index($Dino, $Volcano.z_index)
			$Volcano.z_index = 3

func restart():
	$Dino.prev_index = 1
	$Dino.z_index = 1
	
	$Paisano.prev_index = 2
	$Paisano.z_index = 2
	
	$Volcano.prev_index = 3
	$Volcano.z_index = 3
	
	dragging_card=false
	dragged_card=null
	
	remove_card()
	for control_child_node in get_children():
		control_child_node.restart()
	
	# Hacer visibles los slots y las cartas
	toggle_slots()


func toggle_slots(show: bool = true) -> void:
	for control_child_node in get_children():
		control_child_node.set_visible(show)
