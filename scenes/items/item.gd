class_name Item
extends Area2D

enum ItemType {PROJECTILE, HEALTH, POWERUP}

@export var item_weight: int = 100
@export var item_type: ItemType
@export var item_icon: Texture2D
@export var item_size: Vector2i

var world := GameState.world
var player := GameState.player

var velocity := Vector2.ZERO

func _ready() -> void:
	if world == null:
		world = await EventBus.world_ready
	if player == null:
		player = await EventBus.player_ready
	
	body_entered.connect(self._on_body_entered)

func _physics_process(delta: float) -> void:
	if GameState.paused:
		return
	
	if player == null:
		return
	
	velocity = velocity.move_toward(world.gravity_direction * item_weight, world.gravity)
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.pickup_item(self)
		queue_free()
