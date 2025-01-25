class_name Player
extends CharacterBody3D

@export var gravity_multiplier := 0.0
@export var acceleration := 1
@export var max_move_speed := 1.5

# Remove when death is implemented
var collided_last_frame := false

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var bounce_cooldown: Timer = $BounceCooldown
@onready var camera: PlayerCamera = $Camera3D

func _ready() -> void:
	Globals.player = self

func _on_body_entered(body) -> void:
	if not bounce_cooldown.is_stopped():
		return
	var material = mesh.get_active_material(0)
	material.albedo_color = Color(randf(), randf(), randf())
	bounce_cooldown.start()

func _physics_process(delta: float) -> void:
	var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	var input_dir := Input.get_axis("move_left", "move_right")
	var max_speed_not_reached: bool = abs(velocity.x) < max_move_speed
	var trying_to_break: bool = sign(velocity.x) != sign(input_dir)
	if input_dir != 0 and (max_speed_not_reached or trying_to_break):
		velocity.x = lerp(velocity.x, input_dir * max_move_speed, delta * acceleration)
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		var body: PhysicsBody3D = collision.get_collider()
		if not body.get_collision_layer_value(3):
			collided_last_frame = true
			die()
			return
		hit_bubble(body.owner, collision)
	else:
		velocity += Vector3.DOWN * gravity * gravity_multiplier * delta

func hit_bubble(bubble: Bubble, collision: KinematicCollision3D) -> void:
	bubble.on_hit_by_player()
	velocity = collision.get_normal() * min(8, velocity.length() * 1.2 * bubble.size)
	#camera.zoom_effect()

func die() -> void:
	velocity = Vector3.ZERO

# Probably not supposed to be here
func activate_grativitation(grav_strengh: float = .4) -> void:
	gravity_multiplier = grav_strengh

# Probably not supposed to be here
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#velocity = Vector3.DOWN * .5
		activate_grativitation()
