extends Control
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Variables ▒▒▒▒
var level_finished: bool = false

var _level_started: bool = false
var _can_skip: bool = false
var _intro_step: int = 0
var _skipped: bool = false

onready var level_water: Node2D = $'../../frame/Water'
onready var level_water_anim: AnimationPlayer = level_water.get_node('AnimationPlayer')
onready var level_boat: AnimatedSprite = $'../../frame/Boat'
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Funciones ▒▒▒▒
func _ready():
	level_water.hide()
	# Para asegurar que no se verá el agua así se deje la animación End en el
	# editor: #ChirriDeMierda
	level_water_anim.play('Start', 1.0, -2.0, true)
	level_boat.hide()
	
	$Button.connect('button_down', self, '_on_button_down')
	
	show()

func _play_request(sound):
	EventsManager.emit_signal('play_requested', 'UI', sound)

func _on_button_down():
	if not _level_started:
		start_level()
		EventsManager.emit_signal('play_requested', 'UI', 'Click_St')
	elif _level_started and _can_skip and not level_finished:
		# Cambiar mensaje para que al siguiente clic se salte la animación
		if not $Skip.visible:
			$Skip.show()
		else:
			# TODO: Que se tenga que sostener el clic para saltarla
			_skip()
	elif level_finished:
		$Button.hide()
		$End/Label3.hide()
		EventsManager.emit_signal('play_requested', 'UI', 'Click_End')
		$AnimationPlayer.play('End', -1, -3.0, true)
		yield($AnimationPlayer, 'animation_finished')
		get_parent().get_parent().restart()
		yield(get_tree().create_timer(0.5), 'timeout')
		hide()

func start_level():
	_level_started = true
	_can_skip = true

	$AnimationPlayer.play("Start")
	yield(get_tree().create_timer(3), "timeout")
	_next_step()
	yield(get_tree().create_timer(2.8), "timeout")
	_next_step()
	if not _skipped: 
		EventsManager.emit_signal('play_requested', 'UI', 'Show_Water')
	yield(get_tree().create_timer(1.2), "timeout")
	_next_step()
	yield(get_tree().create_timer(5.3), "timeout")
	_next_step()
	yield(get_tree().create_timer(1.5), "timeout")
	_next_step()
	yield(get_tree().create_timer(2.2), "timeout")
	if not _skipped: 
		EventsManager.emit_signal('play_requested', 'UI', 'Show_Volcano')
	yield(get_tree().create_timer(0.3), "timeout")
	_next_step()
	yield(get_tree().create_timer(3.7), "timeout")
	_next_step()
	yield(get_tree().create_timer(0.7), "timeout")
	$Skip.hide()
	$Button.hide()


func _next_step() -> void:
	if _skipped: return

	match _intro_step:
		0:
			EventsManager.emit_signal('play_requested', 'VO', 'Start')
		1:
			level_water.show()
			level_water_anim.play('Start')
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
	level_water.show()
	level_water_anim.play('End')
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


func finish_level() -> void:
	$AnimationPlayer.playback_speed = 1.0
	yield($AnimationPlayer, 'animation_finished')
	level_finished = true
	yield(get_tree().create_timer(2), "timeout")
	$End/Label3.show()
	$Button.show()
