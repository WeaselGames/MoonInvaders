class_name Bullet
extends Area2D

@export var size: Vector2i = Vector2i(5, 20)
@export var damage: int = 1

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	rotation = velocity.angle() + PI / 2
	position += velocity * delta

	if position.y < 0 or position.y > get_viewport_rect().size.y:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Ship:
		body.apply_damage(damage)
		queue_free()
	elif body is Bullet:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		area.apply_damage(damage)
		queue_free()
