extends RigidBody3D

@export var mesh: MeshInstance3D

func _on_body_entered(body):
	var material = mesh.get_active_material(0)
	material.albedo_color = Color(randf(), randf(), randf())
