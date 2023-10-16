class_name World
extends Node2D

@export var objects: Node2D
@export var gravity: float = 1.62
@export var gravity_direction: Vector2 = Vector2(0, 1)

func _ready() -> void:
	EventBus.world_ready.emit(self)

func add_object(object: CollisionObject2D):
	objects.add_child.call_deferred(object)

func remove_object(object: CollisionObject2D):
	objects.remove_child.call_deferred(object)
