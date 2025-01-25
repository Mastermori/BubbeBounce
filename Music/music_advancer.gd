extends AudioStreamPlayer3D

@export var _loop_Elements: Array[Array]
@onready var _loopTime = $Timer

var _current_loop_index: int

func _ready() -> void:
	_current_loop_index = 0
	_loopTime.start()
	play()
	

func _start_next_loop() -> void:
	if (randf() >= _loop_Elements[_current_loop_index][1]):
		_loopTime.start()
		play()
		print("Did not Advance Audio" )
		return
	var _temp_playback = get_stream_playback()
	#stop()
	#_temp_playback.switch_to_clip_by_name(_loop_Elements[_current_loop_index][0].resource_path.get_file())
	self["parameters/switch_to_clip"] = _loop_Elements[_current_loop_index][0].resource_path.get_file()
	if _current_loop_index < _loop_Elements.size() - 1:
		_current_loop_index += 1
	else:
		_current_loop_index = 0
	_loopTime.start()
	play()
	print("Did Advance Audio t0 " + _loop_Elements[_current_loop_index][0].resource_path.get_file())
