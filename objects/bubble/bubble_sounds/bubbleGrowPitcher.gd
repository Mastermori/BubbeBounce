extends AudioStreamPlayer3D

class_name BubbleSoundPitcher

@onready var _end_grow_emitter = $"../BubbleEndGrowEmitter"

var _is_growing: bool

func start_grow_sound() -> void:
	play()
	_is_growing = true

func stop_grow_sound() -> void:
	stop()
	_end_grow_emitter.play()
	_is_growing = false
