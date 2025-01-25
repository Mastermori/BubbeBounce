class_name PlayerCamera
extends Camera3D

var tween

#func zoom_effect(strength: float = 25, duration: float = .35) -> void:
	#if tween and tween.is_running():
		#return
	#tween = create_tween()
	#var initial_fov = fov
	#tween.tween_property(self, "fov", fov - strength, duration/2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).from_current()
	#tween.tween_property(self, "fov", initial_fov, duration/2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT).from_current()
