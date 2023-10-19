class_name Missile
extends Projectile

@export var animated_sprite: AnimatedSprite2D
@export var vision_cone: VisionCone
@export var yaw_max_speed: float = 4
@export var yaw_acceleration: float = 1
@export var pitbull_max_angle_change: float = 90.0

enum MissileState {ACCELERATE, CRUISE, PITBULL}
var current_state: MissileState = MissileState.ACCELERATE

var rotation_velocity: float = 0
var pitbull_target: Ship
var rotation_change: float = 0
var fail_time: float

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "startup":
		animated_sprite.play("running")

func _on_vision_body_entered(body: Node2D):
	if body is Ship && body != origin && pitbull_target == null:
		pitbull_target = body
		change_state(MissileState.PITBULL)

func _physics_process(delta: float) -> void:
	if GameState.paused:
		return
	
	if velocity.length() >= max_speed:
		change_state(MissileState.CRUISE)
	
	if current_state == MissileState.ACCELERATE:
		velocity = velocity.move_toward(Vector2(max_speed, 0).rotated(rotation), acceleration * delta)
	elif current_state == MissileState.PITBULL && pitbull_target != null:
		var target_angle_diff = position.angle_to_point(pitbull_target.position) - rotation

		if abs(target_angle_diff) > deg_to_rad(2):
			var direction: float = Util.find_fastest_yaw(target_angle_diff)
			rotation_velocity = move_toward(rotation_velocity, direction * yaw_max_speed, yaw_acceleration * delta)
			velocity = velocity.move_toward(Vector2(max_speed, 0).rotated(rotation), acceleration * delta)
			
	position += velocity * delta
	var change = rotation_velocity * delta
	rotation_change += rad_to_deg(change)
	if abs(rotation_change) < abs(pitbull_max_angle_change):
		rotation += change


func projectile_ready():
	animated_sprite.play("startup")
	vision_cone.body_entered.connect(self._on_vision_body_entered)

func change_state(new_state: MissileState):
	current_state = new_state
	if new_state == MissileState.CRUISE:
		animated_sprite.play("cruise")
	elif new_state == MissileState.PITBULL:
		animated_sprite.play("running")
