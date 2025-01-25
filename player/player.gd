class_name Player
extends CharacterBody3D

@export var gravity_multiplier := 0.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var bounce_cooldown: Timer = $BounceCooldown

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
	velocity += Vector3.DOWN * gravity * gravity_multiplier * delta
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		var body: PhysicsBody3D = collision.get_collider()
		if not body.get_collision_layer_value(3):
			die()
			return
		var bubble: Bubble = body.owner
		bubble.on_hit_by_player()
		velocity = collision.get_normal() * min(8, velocity.length() * 1.2) #* 1.05
		# TODO: Add extra velocity when bubble is popping up

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
