class_name Goal
extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Globals.current_level.finish(true)

var original_position: Vector3
var hover_amplitude: float = 20.0  # The height of the hover effect
var hover_speed: float = 2.0  # The speed of the hover effect

func _ready() -> void:
	original_position = position

#func _process(delta: float):
	## Calculate the new Y position using a sine function
	#position.y = original_position.y + sin(OS.get_ticks_usec() * 0.000001 * hover_speed) * hover_amplitude
