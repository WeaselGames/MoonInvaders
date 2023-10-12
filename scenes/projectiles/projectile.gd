class_name Projectile
extends Area2D

@export var size: Vector2i = Vector2i(5, 20)
@export var damage: int = 50
@export var life_span: int = 5
@export var speed: int = 500

var velocity: Vector2 = Vector2.ZERO
var exited: bool = false


func _ready() -> void:
	var timer = Timer.new()
	timer.timeout.connect(self._on_timer_timeout)
	add_child(timer)
	timer.start()
	
	await body_exited
	exited = true

func _physics_process(delta: float) -> void:
	if GameState.paused:
		return
		
	rotation = velocity.angle() + PI / 2
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if not exited:
		return
	
	if body is Ship:
		body.apply_damage(damage)
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		queue_free()

func _on_timer_timeout() -> void:
		queue_free()
