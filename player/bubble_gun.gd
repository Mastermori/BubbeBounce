extends RayCast3D

@export var bubble_scene: PackedScene

@onready var camera: Camera3D = $"../Camera3D"

@onready var player: RigidBody3D = owner
@onready var initial_position := position
@onready var dropPlane := Plane(Vector3(0, 0, 1), player.position.z)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction2D := get_mouse_direction()
	rotation = Vector3(0, 0, direction2D.angle())
	position = initial_position.rotated(Vector3(0, 0, 1), direction2D.angle())

func get_mouse_direction() -> Vector2:
	var mouse_position2D := get_viewport().get_mouse_position()
	var mouse_position3D: Vector3 = dropPlane.intersects_ray(
		camera.project_ray_origin(mouse_position2D),
		camera.project_ray_normal(mouse_position2D))
	var direction := player.position.direction_to(mouse_position3D)
	return Vector2(direction.x, direction.y)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_bubble"):
		var bubble: Bubble = bubble_scene.instantiate()
		Globals.current_level.bubbles.add_child(bubble)
		bubble.global_position = global_position
		bubble.init_shoot(get_mouse_direction())
