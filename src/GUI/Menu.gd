extends Control


func _ready():
	$Button.connect('button_down', self, '_on_button_down')

func _on_button_down():
	start_level()

func start_level():
	$Button.hide()
	$AnimationPlayer.play("Start")
	yield(get_tree().create_timer(3), "timeout")
	EventsManager.emit_signal('play_requested', 'VO', 'Start')
	yield(get_tree().create_timer(2.8), "timeout")
	get_node("../../frame/level_01-bg").show()
	yield(get_tree().create_timer(1.2), "timeout")
	get_node("../../frame/Boat").show()
	yield(get_tree().create_timer(5.3), "timeout")
	$AnimationPlayer.play("ShowDino")
	yield(get_tree().create_timer(1.5), "timeout")
	$AnimationPlayer.play("ShowPaisano")
	yield(get_tree().create_timer(2.5), "timeout")
	$AnimationPlayer.play("ShowVolcano")
	yield(get_tree().create_timer(3.7), "timeout")
	EventsManager.emit_signal('level_started')
	get_node("../Control/Volcano").shake = true
	yield(get_tree().create_timer(0.7), "timeout")
	hide()
	
