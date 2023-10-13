extends Node2D

@export var world_scene: PackedScene
var world: World

@export var player_scene: PackedScene
var player: Player

@export var ui_canvas_layer: CanvasLayer

func _ready() -> void:
	EventBus.start_game.connect(self._on_start_game)
	EventBus.quit_game.connect(self._on_quit_game)
	EventBus.game_over.connect(self._on_game_over)
	EventBus.world_ready.connect(self._on_world_ready)
	EventBus.reset_game.connect(self._on_reset_game)
	UI.set_canvas_layer(ui_canvas_layer)

func _on_start_game():
	world = world_scene.instantiate()
	add_child(world)
	UI.change_menu(UI.Menu.INGAME)

func _on_quit_game():
	world.queue_free()
	UI.change_menu(UI.Menu.MAIN)

func _on_reset_game():
	world.queue_free()
	world = world_scene.instantiate()
	add_child(world)
	UI.change_menu(UI.Menu.INGAME)

func _on_world_ready(_world: World):
	player = player_scene.instantiate()
	world.add_object(player)

func _on_game_over():
	UI.change_menu(UI.Menu.GAMEOVER)
