class_name Goal
extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Globals.current_level.finish(true)
