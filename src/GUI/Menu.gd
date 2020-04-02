extends Control
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Variables ▒▒▒▒
var level_finished: bool = false

var _level_started: bool = false
var _can_skip: bool = false
var _intro_step: int = 0
var _skipped: bool = false

onready var level_bg: Sprite = $'../../frame/level_01-bg'
onready var level_boat: AnimatedSprite = $'../../frame/Boat'
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Funciones ▒▒▒▒
func _ready():
	level_bg.hide()
	level_boat.hide()
	
	$Button.connect('button_down', self, '_on_button_down')
	
	show()

func _on_button_down():
	if not _level_started:
		start_level()
	elif _level_started and _can_skip:
		# Cambiar mensaje para que al siguiente clic se salte la animación
		if not $Skip.visible:
			$Skip.show()
		else:
			# TODO: Que se tenga que sostener el clic para saltarla
			_skip()
	elif level_finished:
		$End/Label3.hide()
		$AnimationPlayer.play('End', -1, -3.0, true)
		yield($AnimationPlayer, 'animation_finished')
		get_parent().get_parent().restart()
		yield(get_tree().create_timer(0.5), 'timeout')
		$Button.hide()
		hide()

func start_level():
	_level_started = true
	_can_skip = true

	$AnimationPlayer.play("Start")
	yield(get_tree().create_timer(3), "timeout")
	_next_step()
	yield(get_tree().create_timer(2.8), "timeout")
	_next_step()
	yield(get_tree().create_timer(1.2), "timeout")
	_next_step()
	yield(get_tree().create_timer(5.3), "timeout")
	_next_step()
	yield(get_tree().create_timer(1.5), "timeout")
	_next_step()
	yield(get_tree().create_timer(2.5), "timeout")
	_next_step()
	yield(get_tree().create_timer(3.7), "timeout")
	_next_step()
	yield(get_tree().create_timer(0.7), "timeout")


func _next_step() -> void:
	if _skipped: return

	match _intro_step:
		0:
			EventsManager.emit_signal('play_requested', 'VO', 'Start')
		1:
			level_bg.show()
		2:
			level_boat.show()
		3:
			$AnimationPlayer.play("ShowDino")
		4:
			$AnimationPlayer.play("ShowPaisano")
		5:
			$AnimationPlayer.play("ShowVolcano")
		6:
			EventsManager.emit_signal('level_started')
			get_node("../Control/Volcano").shake = true

	_intro_step += 1


func _skip() -> void:
	_skipped = true
	
	$AnimationPlayer.playback_speed = 4.0
	# Mostrar fondo del nivel
	level_bg.show()
	level_boat.show()
	# Poner las cartas en sus posiciones Y finales
	$'../Control/Dino'.position.y = 885
	$'../Control/Paisano'.position.y = 885
	$'../Control/Volcano'.position.y = 885
	$'../Control/Volcano'.shake = false # Por si las moscas

	EventsManager.emit_signal('stop_requested', 'VO', 'Start')
	EventsManager.emit_signal('level_started')
	
	$Skip.hide()
	$Button.hide()
