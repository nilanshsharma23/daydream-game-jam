extends Node

var MAIN_MENU_SCENE: PackedScene
var HOW_TO_PLAY_SCENE: PackedScene
var WORLD_SCENE: PackedScene

func _ready() -> void:
	MAIN_MENU_SCENE = load("res://scenes/main_menu.tscn")
	HOW_TO_PLAY_SCENE = load("res://scenes/how_to_play.tscn")
	WORLD_SCENE = load("res://scenes/world.tscn")
