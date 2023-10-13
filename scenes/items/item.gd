class_name Item
extends Area2D

enum ItemType {AMMO, HEALTH, POWERUP}

@export var item_lifespan: int = 30

@export var item_type: ItemType
@export var item_icon: Texture2D

var velocity: Vector2 = Vector2.ZERO

var lifespan_timer: Timer

func _ready() -> void:
	body_entered.connect(self._on_body_entered)
	lifespan_timer = Timer.new()
	lifespan_timer.one_shot = true
	add_child(lifespan_timer)
	lifespan_timer.start(item_lifespan)
	lifespan_timer.timeout.connect(self.queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.pickup_item(self)
		queue_free()
