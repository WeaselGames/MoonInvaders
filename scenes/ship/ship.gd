class_name Ship
extends CharacterBody2D

@export var texture: Texture = preload("res://assets/images/player_ship/player_ship.webp") :
	get:
		return $Sprite.texture
	set(value):
		$Sprite.texture = value
		size = value.get_size()

@export var size: Vector2i = Vector2i(43, 33) :
	get:
		return $CollisionShape2D.shape.size
	set(value):
		$CollisionShape2D.shape.size = value

@export var bullet_scene := preload("res://scenes/bullet/bullet.tscn")

@export var speed: int = 500
@export var max_health: int = 100
@export var health: int = 100 :
	set(value):
		if value > max_health:
			health = max_health
		elif value < 0:
			health = 0
		else:
			health = value
		
		if health == 0:
			ship_destroyed()
	get:
		return health
@export var friction: int = 100
@export var acceleration: int = 25

@export var bullet_direction: int = -1
@export var bullet_speed: int = 750
@export var bullet_damage: int = 1
@export var bullet_cooldown: int = 500

@export var bullet_cooldown_timer: Timer 

var movement_direction: float = 0

func _ready() -> void:
	$CollisionShape2D.shape.size = size

func _physics_process(_delta: float) -> void:
	if GameState.paused:
		return
	
	if movement_direction != 0:
		velocity.x = move_toward(velocity.x, movement_direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	move_and_slide()

func fire() -> void:
	if GameState.paused:
		return
	
	if bullet_cooldown_timer.time_left > 0:
		return
	
	var bullet := bullet_scene.instantiate()
	bullet.position = position + (bullet_direction*-1) * Vector2(0, -(((size.y*scale.y) / 2.0)+(bullet.size.y*bullet.scale.y)))
	bullet.velocity.x = velocity.x
	bullet.velocity.y = bullet_direction * bullet_speed
	bullet.damage = bullet_damage
	get_parent().add_child(bullet)

	bullet_cooldown_timer.start(bullet_cooldown*0.001)

func apply_damage(damage: int) -> void:
	health -= damage

func ship_destroyed() -> void:
	queue_free()
