extends Node2D

@export var items: Array[PackedScene] = []

func _ready() -> void:
	EventBus.enemy_destroyed.connect(self._on_enemy_destroyed)

func _on_enemy_destroyed(enemy: Enemy) -> void:
	var item: Item = items[randi() % items.size()].instantiate()
	item.position = enemy.position
	add_child.call_deferred(item)

func _physics_process(_delta: float) -> void:
	var world_size: Vector2i = GameState.world.size

	var world_x = int(world_size.x/2.0)
	var world_y = int(world_size.y/2.0)

	for child in get_children():
		if child is Ship:
			if child.position.x > world_x:
				child.position.x = -world_x
			if child.position.x < -world_x:
				child.position.x = world_x
			
			if child.position.y > world_y:
				child.position.y = -world_y
			if child.position.y < -world_y:
				child.position.y = world_y
		elif child is Projectile:
			if child.position.x > world_x:
				child.position.x = -world_x
			if child.position.x < -world_x:
				child.position.x = world_x
			
			if child.position.y > world_y:
				child.queue_free()
			if child.position.y < -world_y:
				child.queue_free()
		elif child is Item:
			if child.position.x > world_x:
				child.queue_free()
			if child.position.x < -world_x:
				child.queue_free()
			
			if child.position.y > world_y:
				child.queue_free()
			if child.position.y < -world_y:
				child.queue_free()
		
		

