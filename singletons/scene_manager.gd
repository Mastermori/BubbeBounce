class_name SceneManager
extends Node

@onready var main_menu: Control = $MainMenu

var current_level: Node3D
var current_level_index: int = -1

var levels: Array[PackedScene] = [preload("res://levels/ben_03.tscn"), preload("res://levels/ben_01.tscn"), preload("res://levels/test_level.tscn"), preload("res://levels/ben_04.tscn"), preload("res://levels/ben_02.tscn")]

func _ready() -> void:
	Globals.scene_manager = self

func switch_to_scene(sceneIndex: int) -> void:
	if current_level_index == sceneIndex && current_level != null:
		print("Level already loaded!")
		return

	if sceneIndex >= levels.size():
		print("No more levels!")
		return
	_unload_scene()
	_load_scene(sceneIndex)
	
func _load_scene(sceneIndex: int) -> void:
	var scene = levels[sceneIndex].instantiate()
	current_level_index = sceneIndex
	current_level = scene
	main_menu.visible = false
	self.add_child(scene)
	
func reload_scene() -> void:
	_unload_scene()
	_load_scene(current_level_index)
	
func _unload_scene() -> void:
	if current_level == null:
		return;
	current_level.queue_free()
	current_level = null;

func next_level() -> void:
	switch_to_scene(current_level_index + 1)

func back_to_menu() -> void:
	main_menu.visible = true
	_unload_scene()
