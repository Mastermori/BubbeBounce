class_name Bubble
extends Node3D

var velocity := Vector3.ZERO
var should_bounce := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init_shoot(direction: Vector2, speed: float = 100, size: float = 1.0) -> void:
	velocity = Vector3(direction.x, direction.y, 0) * speed * 1 / size
	scale *= size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity

func _on_body_entered(body: Node3D) -> void:
	velocity = Vector3.ZERO
	should_bounce = true
