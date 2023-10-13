class_name Ship
extends CharacterBody2D

@export var size: Vector2i = Vector2i(43, 33)

@export var default_ammo_scene := preload("res://scenes/projectiles/phaser/phaser.tscn")
@export var default_ammo_icon := preload("res://assets/images/projectile/phaser/red_02.png")

@export var health_bar: HealthBar
@export var sprite: Sprite2D

@export var max_health: int = 100

@export var max_speed: int = 200
@export var max_strafe_speed: int = 100
@export var friction: int = 10
@export var acceleration: int = 15
@export var yaw_acceleration: float = 1
@export var yaw_max_speed: float = 4.0

@export var weapon_hardpoints: Array[Node2D]

signal damage_taken(current_health: int, max_health: int)
signal weapon_fired(ammo: Ammo, cooldown: float, cooldown_timer: Timer)
signal ammo_changed(ammo: Ammo)

class ShipInput:
	var fire: bool = false
	var weapons_up: bool = false
	var weapons_down: bool = false

	var thrust: float
	var yaw: float
	var strafe: float

var input: ShipInput = ShipInput.new()

var ammo: Array[Ammo]
var ammo_index := 0 :
	set(value):
		if value >= ammo.size():
			ammo_index = 0
		elif value < 0:
			ammo_index = ammo.size() - 1
		else:
			ammo_index = value
	get:
		return ammo_index

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

var rotation_velocity: float = 0
var weapon_cooldown: Timer
var last_hardpoint_index := 0

func _ready() -> void:
	weapon_cooldown = Timer.new()
	weapon_cooldown.one_shot = true
	add_child(weapon_cooldown)
	
	health = max_health
	var default_ammo: Ammo = Ammo.new(default_ammo_icon, default_ammo_scene, Projectile.ProjectileType.PHASER, -1)
	ammo.append(default_ammo)

func _physics_process(delta: float) -> void:
	if GameState.paused:
		return
	
	if input.yaw == 0:
		rotation_velocity = move_toward(rotation_velocity, 0, friction)
	else:
		rotation_velocity = move_toward(rotation_velocity, input.yaw * yaw_max_speed, yaw_acceleration)
	
	rotation += rotation_velocity * delta
	
	if input.thrust == 0 and input.strafe == 0:
		velocity = velocity.move_toward(Vector2(0, 0), friction) 
	else:
		velocity = velocity.move_toward(Vector2(input.strafe * max_strafe_speed, input.thrust * max_speed).rotated(rotation), acceleration)
	
	move_and_slide()

func _process(_delta: float) -> void:
	if input.weapons_up:
		ammo_index += 1
		ammo_changed.emit(ammo[ammo_index])
		input.weapons_up = false
	if input.weapons_down:
		ammo_index -= 1
		ammo_changed.emit(ammo[ammo_index])
		input.weapons_down = false

	if input.fire:
		fire()
		input.fire = false

func fire() -> void:
	if weapon_cooldown.time_left > 0:
		return
	
	var ammo_to_fire: Ammo = ammo[ammo_index]
	
	var i: int = last_hardpoint_index + 1
	if i >= weapon_hardpoints.size(): i = 0
	while weapon_hardpoints[i].hardpoint_type != ammo_to_fire.projectile_type:
		i += 1
		if i >= weapon_hardpoints.size(): i = 0
	
	var cooldown: float = weapon_hardpoints[i].fire(self)
	ammo_to_fire.consume_ammo()
	last_hardpoint_index = i
	weapon_cooldown.start(cooldown)
	weapon_fired.emit(ammo_to_fire, cooldown, weapon_cooldown)
	if ammo_to_fire.projectile_count == 0:
		ammo.erase(ammo_to_fire)
		ammo_index -= 1
		ammo_changed.emit(ammo[ammo_index])

func get_input() -> ShipInput:
	return input

func apply_damage(damage: int) -> void:
	health -= damage
	damage_taken.emit(health, max_health)

func ship_destroyed() -> void:
	queue_free()
