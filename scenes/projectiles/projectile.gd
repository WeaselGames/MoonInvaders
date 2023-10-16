class_name Projectile
extends Area2D

enum ProjectileType {PHASER, MISSILE}

@export var size: Vector2i = Vector2i(5, 20)
@export var damage: int = 50
@export var life_span: int = 5
@export var speed: int = 500
@export var cooldown: int = 100
@export var projectile_type: ProjectileType

var velocity: Vector2 = Vector2.ZERO
var origin: Ship
var origin_position: Vector2

func _ready() -> void:
	var timer = Timer.new()
	timer.timeout.connect(self._on_timer_timeout)
	timer.one_shot = true
	add_child(timer)
	timer.start(life_span)
	body_entered.connect(self._on_body_entered)
	origin_position = position

func _physics_process(delta: float) -> void:
	if GameState.paused:
		return
		
	rotation = velocity.angle()
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Ship && body != origin:
		body.apply_damage(origin_position, damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		queue_free()

func _on_timer_timeout() -> void:
		queue_free()
