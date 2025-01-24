class_name Player
extends RigidBody3D

@export var mesh: MeshInstance3D

func _ready() -> void:
	Globals.player = self

func _on_body_entered(body):
	var material = mesh.get_active_material(0)
	material.albedo_color = Color(255, 0, 0)
