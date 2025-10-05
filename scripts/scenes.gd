extends Node

var MAIN_MENU_SCENE: PackedScene
var HOW_TO_PLAY_SCENE: PackedScene
var CREDITS_SCENE: PackedScene
var LEVEL_1_SCENE: PackedScene

func _ready() -> void:
	MAIN_MENU_SCENE = load("res://scenes/main_menu.tscn")
	HOW_TO_PLAY_SCENE = load("res://scenes/how_to_play.tscn")
	CREDITS_SCENE = load("res://scenes/credits.tscn")
	LEVEL_1_SCENE = load("res://scenes/level1.tscn")
