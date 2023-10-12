class_name Ship
extends CharacterBody2D

@export var size: Vector2i = Vector2i(43, 33)

@export var projectile_scene := preload("res://scenes/projectiles/projectile.tscn")

@export var health_bar: HealthBar
@export var sprite: Sprite2D

@export var max_speed: int = 500
@export var max_health: int = 100

@export var friction: int = 10
@export var acceleration: int = 15

@export var ship_direction: int = -1
@export var projectile_cooldown: int = 500
 
var projectile_cooldown_timer: Timer 

var movement_direction: float = 0

var health: int = max_health :
	set(value):
		if value > max_health:
			health = max_health
		elif value < 0:
			health = 0
		else:
			health = value
		
		if health == 0:
			ship_destroyed()
		
		health_bar.update(health, max_health)
	get:
		return health

signal damage_taken(current_health: int, max_health: int)

func _ready() -> void:
	health = max_health
	projectile_cooldown_timer = Timer.new()
	projectile_cooldown_timer.one_shot = true
	add_child(projectile_cooldown_timer)

func _physics_process(_delta: float) -> void:
	if GameState.paused:
		return
	
	if movement_direction != 0:
		velocity.x = move_toward(velocity.x, movement_direction * max_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	var fake_velocity = Vector2(velocity.x, max_speed * ship_direction)
	sprite.rotation = fake_velocity.angle() + PI / 2
	
	move_and_slide()

func fire() -> void:
	if GameState.paused:
		return
	
	if projectile_cooldown_timer.time_left > 0:
		return
	
	var projectile := projectile_scene.instantiate()
	projectile.position = position
	projectile.velocity = Vector2(0, -projectile.speed).rotated(sprite.rotation)
	get_parent().add_child(projectile)

	projectile_cooldown_timer.start(projectile_cooldown*0.001)

func apply_damage(damage: int) -> void:
	health -= damage
	damage_taken.emit(health, max_health)

func ship_destroyed() -> void:
	queue_free()
