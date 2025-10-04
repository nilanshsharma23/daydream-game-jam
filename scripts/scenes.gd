extends Node

var MAIN_MENU_SCENE: PackedScene
var WORLD_SCENE: PackedScene

func _ready() -> void:
	MAIN_MENU_SCENE = load("res://scenes/main_menu.tscn")
	WORLD_SCENE = load("res://scenes/world.tscn")
