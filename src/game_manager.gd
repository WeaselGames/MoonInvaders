extends Node

var world_scene: PackedScene = preload("res://scenes/world/world.tscn")
var world: World

var player_scene: PackedScene = preload("res://scenes/ships/player/player.tscn")
var player

func _ready() -> void:
	EventBus.start_game.connect(self._start_game)
	EventBus.quit_game.connect(self._quit_game)
	EventBus.world_ready.connect(self._world_ready)
	EventBus.enemy_manager_ready.connect(self._on_enemy_manager_ready)

func _start_game() -> void:
	world = world_scene.instantiate()
	add_child(world)
	UI.change_menu(UI.Menu.INGAME)

func _quit_game() -> void:
	if world != null:
		world.queue_free()
	UI.change_menu(UI.Menu.MAIN)

func _world_ready(_world: World):
	player = player_scene.instantiate()
	_world.add_object(player)

func _on_enemy_manager_ready():
	EnemyManager.next_wave()

func pause_game() -> void:
	GameState.paused = true

func resume_game() -> void:
	GameState.paused = false
