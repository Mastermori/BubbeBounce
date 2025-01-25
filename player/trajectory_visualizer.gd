extends Node3D

@export var color_gradient: Gradient

@onready var ray: RayCast3D = $"../TrajectoryRay"
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var material := ORMMaterial3D.new()

const MAX_TIME := 2. # Sec
const TIME_STEP := 0.08 # Sec
const GRAV_ACC := -9.8 * .4 # Meters/Sec^2

func _ready() -> void:
	top_level = true
	global_position = Vector3.ZERO

# theta in radians, otherwise use deg_to_rad() before-hand
func solve_path(start_position: Vector2, v_0: float, theta: float):
	var pts := PackedVector2Array([])
	var t: float = 0.
	var x: float = start_position.x
	var y: float = start_position.y
	
	# Godot y-axis is flipped
	var v_x: float = v_0 * cos(theta)
	var v_y: float = v_0 * sin(theta)
	
	# Very crude algorithm, specifically this is the "Euler method"
	# For more sophesticated situations (ie > 1 projectile interacting with each other)
	# use "Runge-Kutta Methods" or "Verlet Integration Methods"
	while t < MAX_TIME: # No infinities
		v_y += GRAV_ACC * TIME_STEP
		v_x += 0 # No X Forces (no drag)
		t += TIME_STEP
		x += v_x * TIME_STEP
		y += v_y * TIME_STEP
		pts.push_back(Vector2(x, y))
		if ray_intersects(start_position, Vector2(x, y)): # hit an object
			break
	draw_lines(pts)

func ray_intersects(start_point: Vector2, point: Vector2) -> bool:
	ray.target_position = Vector3(point.x - start_point.x, point.y - start_point.y, 0)
	ray.force_raycast_update()
	return ray.is_colliding()

func draw_lines(points: Array[Vector2]):
	if points.size() < 2:
		return
	var immediate_mesh := ImmediateMesh.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	for i in range(0, points.size() - (0 if points.size() % 2 == 0 else 1), 1):
		var pos1 = points[i]
		immediate_mesh.surface_set_color(color_gradient.sample(1 - 1.0 * i / points.size()))
		immediate_mesh.surface_add_vertex(Vector3(pos1.x, pos1.y, 0))
	immediate_mesh.surface_end()
