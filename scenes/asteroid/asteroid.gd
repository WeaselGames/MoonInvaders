class_name Asteroid
extends Area2D

@export var rotation_speed: float = 0.5
@export var damage: int = 250
@export var health: int = 100

var velocity: Vector2 = Vector2.ZERO

var size: Vector2i :
	get:
		return $CollisionShape2D.shape.size
	set(value):
		$CollisionShape2D.shape.size = value

func _physics_process(delta: float) -> void:
	rotation += rotation_speed * delta
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Ship:
		body.apply_damage((damage))

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
