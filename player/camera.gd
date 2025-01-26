class_name PlayerCamera
extends Camera3D

@onready var player = $".."

var playerTransform

var tween

var viewport : Viewport

var speed_threshold = 5
var fast_speed_multiplier = 3


var fixed_z_value: float = 0.0  # You can adjust this to your needs
	
#func zoom_effect(strength: float = 25, duration: float = .35) -> void:
	#if tween and tween.is_running():
		#return
	#tween = create_tween()
	#var initial_fov = fov
	#tween.tween_property(self, "fov", fov - strength, duration/2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).from_current()
	#tween.tween_property(self, "fov", initial_fov, duration/2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT).from_current()
	


func _ready() -> void:
	viewport = get_viewport()
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var mouse_position := viewport.get_mouse_position()
	var origin := project_ray_origin(mouse_position)
	var direction := project_ray_normal(mouse_position)	
	var ray_length := far
	var end := origin + direction * ray_length
	#end.z = fixed_z_value  # Lock the Z-axis to the defined plane
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	
	# Only interact with objects on the fixed Z-plane
	query.set_collision_mask(1) # Set to your desired collision layer
	
	var result := space_state.intersect_ray(query)
	var mouse_position_3D:Vector3 = result.get("position", end)
	var local_mouse_position: Vector3 = player.to_local(mouse_position_3D)
	local_mouse_position.z = 0.0
	
	var midpoint: Vector3 = (player.position + mouse_position_3D) / 2
	# Calculate the midpoint between player and mouse position
	var local_midpoint: Vector3 = player.to_local(midpoint)/2
	
	local_midpoint.z = self.position.z

	var movement_speed: float = 4.0  # Adjust this speed as needed
	if position.length() > speed_threshold:
		movement_speed *= fast_speed_multiplier
	self.position = self.position.lerp(local_midpoint, movement_speed * delta)
