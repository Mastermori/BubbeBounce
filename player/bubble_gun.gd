extends RayCast3D

@export var bubble_scene: PackedScene

@export var _soundEmitter: AudioStreamPlayer3D

@onready var camera: Camera3D = $"../Camera3D"

@onready var crosshair: Area3D = $"../Crosshair"

@onready var player: Player = owner
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
	if not is_colliding():
		crosshair.visible = false
		return
	crosshair.global_position.x = get_collision_point().x
	crosshair.global_position.y = get_collision_point().y
	crosshair.visible = true
	

func get_mouse_direction() -> Vector2:
	var mouse_position2D := get_viewport().get_mouse_position()
	var mouse_position3D: Vector3 = dropPlane.intersects_ray(
		camera.project_ray_origin(mouse_position2D),
		camera.project_ray_normal(mouse_position2D))
	var direction := player.position.direction_to(mouse_position3D)
	return Vector2(direction.x, direction.y)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_bubble"):
		force_raycast_update()
		if not is_colliding():
			return
		var bubble: Bubble = bubble_scene.instantiate()
		Globals.current_level.bubbles.add_child(bubble)
		bubble.global_position = get_collision_point()
		print(bubble.global_position)
		bubble.start_growing()
		_playShootSound()

func _playShootSound():
	_soundEmitter.play(0)
