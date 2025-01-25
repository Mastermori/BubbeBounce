class_name Player
extends CharacterBody3D

@export var gravity_multiplier := 0.0
@export var acceleration := 1
@export var max_move_speed := 1.5
@export var _min_bubble_boost : int

# Remove when death is implemented
var collided_last_frame := false
var rotation_impulse: float = 0

var has_level_started: bool = false

@onready var mesh: MeshInstance3D = $Body/MeshInstance3D
@onready var bounce_cooldown: Timer = $BounceCooldown
@onready var camera: PlayerCamera = $Camera3D
@onready var capybara: Node3D = $Body/capybara
@onready var trail: Trail3D = $Body/capybara/Trail3D

func _ready() -> void:
	Globals.player = self

func _on_body_entered(body) -> void:
	if not bounce_cooldown.is_stopped():
		return
	var material = mesh.get_active_material(0)
	material.albedo_color = Color(randf(), randf(), randf())
	bounce_cooldown.start()

func _physics_process(delta: float) -> void:
	if !has_level_started:
		return
	var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	var input_dir := Input.get_axis("move_left", "move_right")
	var max_speed_not_reached: bool = abs(velocity.x) < max_move_speed
	var trying_to_break: bool = sign(velocity.x) != sign(input_dir)
	if input_dir != 0:
		capybara.rotate_z(delta * acceleration * -input_dir * 1.5)
		if max_speed_not_reached or trying_to_break:
			velocity.x = lerp(velocity.x, input_dir * max_move_speed, delta * acceleration)
	
	capybara.rotate_z(rotation_impulse)
	rotation_impulse *= (1 - .65 * delta)
	
	camera.fov = lerp(camera.fov, 75 * clamp(.95 + velocity.length() / 8 * .35, .95, 1.3), delta)
	
	var collision := move_and_collide(velocity * delta)
	if collision and not collided_last_frame:
		collided_last_frame = true
		var body: PhysicsBody3D = collision.get_collider()
		if not body.get_collision_layer_value(3):
			die()
			return
		hit_bubble(body.owner, collision)
	else:
		collided_last_frame = false
		velocity += Vector3.DOWN * gravity * gravity_multiplier * delta
		$Trajectory/TrajectoryVisualizer.solve_path(Vector2(global_position.x, global_position.y), velocity.length(), Vector2.RIGHT.angle_to(Vector2(velocity.x, velocity.y)))
	
	if position.y < -10:
		die()

func hit_bubble(bubble: Bubble, collision: KinematicCollision3D) -> void:
	bubble.on_hit_by_player()
	var collision_normal := collision.get_normal()
	collision_normal.z = 0
	collision_normal = collision_normal.normalized() 
	var bubble_multiplier := bubble.size if bubble.size < 1 else pow(bubble.size, 2) 
	if (collision_normal * min(8, velocity.length() * 1.2 * bubble_multiplier)).length() > _min_bubble_boost:
		velocity = collision_normal * min(8, velocity.length() * 1.2 * bubble_multiplier)
	else:
		velocity = collision_normal.normalized()*_min_bubble_boost
	var angle_percent := Vector2.DOWN.angle_to(Vector2(collision_normal.x, collision_normal.y)) / (2 * PI)
	rotation_impulse = clamp(rotation_impulse + sign(angle_percent) * pow(angle_percent, 2) * bubble.size, -1, 1)
	trail.emit = velocity.length() > 6

func die() -> void:
	Globals.current_level.finish(false)
	velocity = Vector3.ZERO

# Probably not supposed to be here
func activate_grativitation(grav_strengh: float = .4) -> void:
	gravity_multiplier = grav_strengh

# Probably not supposed to be here
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#velocity = Vector3.DOWN * .5
		activate_grativitation()
		has_level_started = true
