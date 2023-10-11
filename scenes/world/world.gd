class_name World
extends Node2D

@export var ships: Node2D
@export var asteroids: Node2D

func _physics_process(_delta: float) -> void:
	var viewport_size = get_viewport().size
	for child in ships.get_children():
		if child is Ship or child is Bullet:
			if child.position.x > viewport_size.x:
				child.position.x = 0
			if child.position.x < 0:
				child.position.x = viewport_size.x
	
	for child in asteroids.get_children():
		if child.position.x > viewport_size.x:
			child.position.x = 0
		if child.position.x < 0:
			child.position.x = viewport_size.x
		if child.position.y > viewport_size.y:
			child.position.y = 0
		if child.position.y < 0:
			child.position.y = viewport_size.y
			
	
