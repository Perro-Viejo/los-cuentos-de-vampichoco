extends Node2D

var _audio_maps: Dictionary = {}

func _ready():
	EventsManager.connect('play_requested', self, '_on_play_requested')
	EventsManager.connect('stop_requested', self, '_on_stop_requested')
	EventsManager.connect('pause_requested', self, '_pause_sound')

func _get_audio(source, sound) -> Node:
	return get_node(''+source+'/'+sound)

func _on_play_requested(source, sound) -> void:
	var audio: Node = _get_audio(source, sound)

	if audio.get('stream_paused'):
		audio.stream_paused = false
	else:
		audio.play()


func _on_stop_requested(source, sound) -> void:
	_get_audio(source, sound).stop()


func _pause_sound(source, sound) -> void:
	_get_audio(source, sound).stream_paused = true
