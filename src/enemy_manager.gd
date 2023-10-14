extends Node

var world: World
var player: Player
var wave = 0

var enemy_scene = preload("res://scenes/ships/enemy/enemy.tscn")
var enemies: Array[Enemy]

func _on_world_ready(_world: World) -> void:
	self.world = _world

func _on_player_ready(_player: Player) -> void:
	self.player = _player
	next_wave()

func _on_enemy_destroyed(enemy: Enemy) -> void:
	enemies.erase(enemy)
	if enemies.size() == 0:
		next_wave()

func _ready() -> void:
	EventBus.player_ready.connect(self._on_player_ready)
	EventBus.world_ready.connect(self._on_world_ready)
	EventBus.enemy_destroyed.connect(self._on_enemy_destroyed)
	
	if world == null:
		await EventBus.world_ready
	if player == null:
		await EventBus.player_ready
	
	EventBus.enemy_manager_ready.emit()

func set_starting_position(enemy: Enemy, n: int, count: int) -> void:
	enemy.position.y = player.position.y - 500
	enemy.position.x = player.position.x + (get_viewport().size.x / count) * n

func next_wave() -> void:
	wave += 1
	for i in range(wave):
		var enemy = enemy_scene.instantiate()
		enemies.append(enemy)
		world.add_object(enemy)
		set_starting_position(enemy, i, wave)
