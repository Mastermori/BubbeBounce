extends AudioStreamPlayer3D

class_name BubbleSoundPitcher

@onready var _end_grow_emitter = $BubbleEndGrowEmitter
@onready var _timeout_emitter = $BubbleTimeoutEmitter

var _is_growing: bool

func start_grow_sound() -> void:
	play()
	_is_growing = true

func play_timeout_sound() -> void:
	_timeout_emitter.play()

func stop_grow_sound(bubble_sound: float) -> void:
	stop()
	_end_grow_emitter.set_volume_db(_end_grow_emitter.get_volume_db() + 0.5 + (abs(bubble_sound-0.5)/19)*100) 
	_end_grow_emitter.play()
	_is_growing = false
