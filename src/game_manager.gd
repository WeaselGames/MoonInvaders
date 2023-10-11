extends Node

var world_scene: PackedScene = preload("res://scenes/world/world.tscn")
var world: World

# @onready var game = get_node("/root/Game")

func _ready() -> void:
	EventBus.start_game.connect(self._start_game)
	EventBus.quit_game.connect(self._quit_game)

func _start_game() -> void:
	world = world_scene.instantiate()
	add_child(world)
	UI.change_menu(UI.Menu.INGAME)

func _quit_game() -> void:
	if world != null:
		world.queue_free()
	UI.change_menu(UI.Menu.MAIN)

func pause_game() -> void:
	GameState.paused = true

func resume_game() -> void:
	GameState.paused = false
