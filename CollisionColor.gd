extends RigidBody3D

@export var mesh: MeshInstance3D

func _on_body_entered(body):
	var material = mesh.get_active_material(0)
	material.albedo_color = Color(randf(), randf(), randf())
	apply_impulse(-linear_velocity)
	print("Colllision")

# Probably not supposed to be here
func _activate_grativitation(gravStrengh: float):
	gravity_scale = gravStrengh

# Probably not supposed to be here
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_activate_grativitation(0.1 )
