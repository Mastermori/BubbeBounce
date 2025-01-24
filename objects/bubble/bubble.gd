class_name Bubble
extends Node3D

var velocity := Vector3.ZERO
var should_bounce := false
var size := 1.0

@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/StaticBody3D/CollisionShape3D
@onready var fade_timer: Timer = $FadeTimer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init_shoot(direction: Vector2, speed: float = .15, size: float = 1.0) -> void:
	velocity = Vector3(direction.x, direction.y, 0) * speed * 1 / size
	self.size = size
	scale = Vector3.ONE * .3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity

func _on_body_entered(body: Node3D) -> void:
	velocity = Vector3.ZERO
	should_bounce = true
	collision_shape_3d.set_deferred("disabled", false)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, .3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE).from_current()
	fade_timer.start(2)

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * 1.6, .25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).from_current()
	tween.parallel().tween_method(func (alpha): mesh_instance_3d.set_instance_shader_parameter("alpha_multipler", alpha), 1.0, 0.0, .25).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)
