class_name Bubble
extends Area3D

var size := 1.0
var current := false


@export var fade_timer_after_hit: float = .01
@export var base_fade_timer: float = 6
@export var growth_factor: float = 2
@export var max_size: float = 10

@onready var _sound_emitter: BubbleSoundPitcher = $BubbleLandSoundEmitter
@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/StaticBody3D/CollisionShape3D
@onready var fade_timer: Timer = $FadeTimer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var timer_label: Label3D = $TimerLabel

func _process(delta: float) -> void:
	if current:
		if Input.is_action_pressed("shoot_bubble"):
			grow(delta)
		else:
			finish_growing()
	else:
		timer_label.text = "%.2f" % fade_timer.time_left

func grow(delta: float) -> void:
	size += growth_factor * delta
	scale = Vector3.ONE * size
	if size >= max_size:
		finish_growing()

func start_growing(start_size: float = .3) -> void:
	self.size = start_size
	scale = Vector3.ONE * start_size
	_sound_emitter
	current = true
	_sound_emitter.start_grow_sound()

func finish_growing() -> void:
	current = false
	collision_shape_3d.set_deferred("disabled", false)
	fade_timer.start(base_fade_timer * size / 2)
	_sound_emitter.stop_grow_sound()
	

func _on_body_entered(body: PhysicsBody3D) -> void:
	current = false
	_fade_out()

func on_hit_by_player() -> void:
	if fade_timer.time_left > fade_timer_after_hit:
		fade_timer.start(fade_timer_after_hit)

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * 1.6, .25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).from_current()
	tween.parallel().tween_method(func (alpha): mesh_instance_3d.set_instance_shader_parameter("alpha_multipler", alpha), 1.0, 0.0, .25).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)
