class_name Character
extends Node2D

var _current_character = ""

onready var dino: AnimatedSprite = $Dino
onready var paisano: AnimatedSprite = $Paisano
onready var volcano: AnimatedSprite = $Volcano
onready var dino_dflt_y: float = dino.position.y

func _ready() -> void:
	register_listener(dino, 'dino')
	register_listener(paisano, 'paisano')
	register_listener(volcano, 'volcano')

func character_show(current_character):
	_current_character = current_character
	
	if current_character == "Dino":
		$Dino.show()
		$Dino.play("Idle")
	if current_character == "Paisano":
		$Paisano.show()
		$Paisano.play("Idle")
	if current_character == "Volcano":
		$Volcano.show()
		$Volcano.play("Idle")

func character_hide(current_character):
	_current_character = current_character
	
	if current_character == "Dino":
		$Dino.hide()
		$Dino.stop()
		if dino.animation == 'Dance':
			EventsManager.emit_signal('stop_requested', 'Dino', 'Dance')
		if dino.animation == 'Sleep':
			EventsManager.emit_signal('stop_requested', 'Dino', 'Sleep')
	if current_character == "Paisano":
		$Paisano.hide()
		$Paisano.stop()
	if current_character == "Volcano":
		$Volcano.hide()
		$Volcano.stop()
		if volcano.animation == 'Dance':
			EventsManager.emit_signal('stop_requested', 'Volcano', 'Dance')

func restart():
	_current_character = ""
	$Dino.hide()
	$Dino.stop()
	$Paisano.hide()
	$Paisano.stop()
	$Volcano.hide()
	$Volcano.stop()


func play_anim(id) -> void:
	var node: AnimatedSprite
	
	match _current_character:
		"Dino":
			node = $Dino
			
			if id == 'Eat':
				dino.position.y = dino_dflt_y - 32
			else:
				dino.position.y = dino_dflt_y
				
			# Reproducir SFXs
			match id:
				'Run':
					EventsManager.emit_signal('play_requested', 'Dino', 'Scream')
				'Drown':
					EventsManager.emit_signal('play_requested', 'Dino', id)
		"Paisano":
			node = $Paisano
			
			# Reproducir SFXs
			if id == 'Walk':
				EventsManager.emit_signal('play_requested', 'Paisano', 'Walk')
		"Volcano":
			node = $Volcano
			
			# Reproducir SFXs
			if id == 'Erupt':
				EventsManager.emit_signal('play_requested', 'Volcano', 'Explode')
	
	node.play(id)


func stop_anim() -> void:
	var node: AnimatedSprite
	
	match _current_character:
		"Dino":
			node = $Dino
		"Paisano":
			node = $Paisano
		"Volcano":
			node = $Volcano
	
	node.stop()


func register_listener(node: AnimatedSprite, id: String) -> void:
# warning-ignore:return_value_discarded
	node.connect('animation_finished', self, '_on_animation_finished', [id])
	node.connect('frame_changed', self, '_on_frame_changed', [id])


func _on_animation_finished(src: String) -> void:
	match src:
		'volcano':
			if volcano.animation == 'Erupt':
				volcano.play('EruptLoop')
		'dino':
			if dino.animation == 'Eat':
				dino.position.y = dino_dflt_y

				dino.play('Dance')
				EventsManager.emit_signal('play_requested', 'Dino', 'Dance')
		'paisano':
			if paisano.animation == 'Climb':
				paisano.play('ClimbLoop')
				
func _on_frame_changed(src: String) -> void:
	match src:
		'dino':
			if $Dino.animation == "Run":
				if $Dino.get_frame() == 1 or $Dino.get_frame() == 5:
					EventsManager.emit_signal('play_requested', 'Dino', 'FS')
			if $Dino.animation == "Walk":
				if $Dino.get_frame() == 0 or $Dino.get_frame() == 3:
					EventsManager.emit_signal('play_requested', 'Dino', 'FS')
		'paisano':
			pass
		'volcano':
			pass
