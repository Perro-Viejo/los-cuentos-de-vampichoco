class_name Character
extends Node2D
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Variables ▒▒▒▒
export(int) var despair_to_die = 20

var _current_character: String = ""
var _despair_count: int = 0

onready var dino: AnimatedSprite = $Dino
onready var paisano: AnimatedSprite = $Paisano
onready var volcano: AnimatedSprite = $Volcano
onready var dino_dflt_y: float = dino.position.y
onready var volcano_dflt_y: float = volcano.position.y
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Funciones ▒▒▒▒
func _ready() -> void:
	register_listener(dino, 'dino')
	register_listener(paisano, 'paisano')
	register_listener(volcano, 'volcano')

func character_show(current_character):
	_current_character = current_character
	EventsManager.emit_signal('play_requested', current_character , 'Show')
	
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
	show()
	stop_anim()

	_current_character = ''
	
	dino.position.y = dino_dflt_y
	volcano.position.y = volcano_dflt_y
	
	for anim_sprite in get_children():
		anim_sprite.hide()


func play_anim(id: String) -> void:
	var node: AnimatedSprite
	
	match _current_character:
		"Dino":
			node = $Dino

			match id:
				'Eat':
					dino.position.y = dino_dflt_y - 32
					EventsManager.emit_signal('play_requested', 'Dino', 'Eat')
				'Run':
					EventsManager.emit_signal('play_requested', 'Dino', 'Scream')
				'Drown':
					EventsManager.emit_signal('play_requested', 'Dino', id)
				'Sleep':
					EventsManager.emit_signal('play_requested', 'Dino', 'Sleep')
				'Dance':
					EventsManager.emit_signal('play_requested', 'Dino', 'Dance')
				'Burn':
					_burn(node.position)
					EventsManager.emit_signal('stop_requested', 'Dino', 'Sleep')
					EventsManager.emit_signal('play_requested', 'Dino', 'Scream')
					EventsManager.emit_signal('play_requested', 'Dino', 'Burn')
					node.hide()
					return
		"Paisano":
			node = $Paisano
			
			match id:
				'Walk', 'Dance', 'DanceAlone':
					EventsManager.emit_signal('play_requested', 'Paisano', 'Walk')
				'Climb':
					EventsManager.emit_signal('play_requested', 'Paisano', 'Climb')
				'Burn':
					_burn(node.position)
					node.hide()
					return
		"Volcano":
			node = $Volcano
			
			match id:
				'Erupt':
					volcano.position.y = volcano_dflt_y - 16
					EventsManager.emit_signal('play_requested', 'Volcano', 'Explode')
				'Dance':
					volcano.position.y = volcano_dflt_y - 24
					EventsManager.emit_signal('play_requested', 'Volcano', 'Dance')
	
	node.play(id)


func stop_anim() -> void:
	var node: AnimatedSprite
	
	match _current_character:
		"Dino":
			node = $Dino
			
			if dino.animation == 'Dance':
				EventsManager.emit_signal('stop_requested', 'Dino', 'Dance')
		"Paisano":
			node = $Paisano
		"Volcano":
			node = $Volcano
			
			if volcano.animation == 'Dance':
				EventsManager.emit_signal('stop_requested', 'Volcano', 'Dance')
	
	if node.stop() in node:
		node.stop()


func register_listener(node: AnimatedSprite, id: String) -> void:
	node.connect('animation_finished', self, '_on_animation_finished', [id])
	node.connect('frame_changed', self, '_on_frame_changed', [id])


func _on_animation_finished(src: String) -> void:
	match src:
		'volcano':
			if volcano.animation == 'Erupt':
				volcano.play('EruptLoop')
#			elif volcano.animation == 'Dance':
#				volcano.position.y = volcano_dflt_y - 32
		'dino':
			if dino.animation == 'Eat':
				dino.position.y = dino_dflt_y

				dino.play('Dance')
				EventsManager.emit_signal('play_requested', 'Dino', 'Dance')
		'paisano':
			match paisano.animation:
				'Climb':
					paisano.play('ClimbLoop')
				'ClimbLoop':
					_despair_count += 1
					if _despair_count == despair_to_die:
						_despair_count = 0

						paisano.stop()
						paisano.hide()
						
						# TODO: Reproducir el sonido de muerte con sufrimiento
						# del paisano
						# EventsManager.emit_signal('play_requested', 'Paisano', 'Scream')
						
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
			if $Paisano.animation == 'Climb':
				if $Paisano.frame == 6:
					_burn($Paisano.position)
		'volcano':
			pass


func _burn(position: Vector2) -> void:
	$Fire.position = position
	
	$Fire.show()
	EventsManager.emit_signal('play_requested', 'Paisano', 'Burn')
	$Fire.play('Burn')
