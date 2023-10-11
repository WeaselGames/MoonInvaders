extends Node2D

@export var max_asteroid_count: int = 5
@export var asteroid_scene: PackedScene

func _on_asteriod_spawn_timer_timeout() -> void:
	spawn_asteroid()

func spawn_asteroid() -> void:
	if get_child_count() < max_asteroid_count:
		var asteroid = asteroid_scene.instantiate()
		var spawn_side = randi_range(0, 1)
		var spawn_x = 0
		var spawn_y = randi_range(0, get_viewport_rect().size.y-(asteroid.size.y*asteroid.scale.y))
		asteroid.velocity = Vector2(randf_range(100, 200), randf_range(-50, 50))
		if spawn_side != 0:
			spawn_x = get_viewport_rect().size.x
			asteroid.velocity.x *= -1
		
		asteroid.position = Vector2(spawn_x, spawn_y)
		asteroid.rotation_speed = randf_range(-5, 5)
		add_child(asteroid)

func clear_asteroids() -> void:
	for child in get_children():
		child.queue_free()
			
