extends Node2D

var _audio_maps: Dictionary = {}
var _sources: Array = []

func _ready():
	for src in get_children():
		_sources.append(src.name)
	
	EventsManager.connect('play_requested', self, 'play_sound')
	EventsManager.connect('stop_requested', self, 'stop_sound')
	EventsManager.connect('pause_requested', self, 'pause_sound')

func _get_audio(source, sound) -> Node:
	return get_node(''+source+'/'+sound)

func play_sound(source: String, sound: String) -> void:
	var audio: Node = _get_audio(source, sound)

	if audio.get('stream_paused'):
		audio.stream_paused = false
	else:
		audio.play()


func stop_sound(source: String, sound: String) -> void:
	_get_audio(source, sound).stop()


func pause_sound(source: String, sound: String) -> void:
	var audio: Node = _get_audio(source, sound)
	
	if not audio.get('stream_paused'):
		audio.stream_paused = true
