extends Node2D

@export var items: Array[PackedScene] = []

var _player: Player

func _ready() -> void:
	EventBus.enemy_destroyed.connect(self._on_enemy_destroyed)
	EventBus.player_ready.connect(self._on_player_ready)

func _on_enemy_destroyed(enemy: Enemy) -> void:
	var item: Item = items[randi() % items.size()].instantiate()
	item.position = enemy.position
	add_child.call_deferred(item)

func _on_player_ready(player: Player):
	_player = player

func _physics_process(_delta: float) -> void:
	if GameState.paused || _player == null:
		return

	for child in get_children():
		if child is Ship or child is Projectile or child is Item:
			if abs(child.position.distance_to(_player.position)) > 2500:
				child.queue_free()
				EventBus.object_cleared.emit(child)
