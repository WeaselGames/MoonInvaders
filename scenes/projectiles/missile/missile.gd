class_name Missile
extends Projectile

@export var animated_sprite: AnimatedSprite2D
@export var vision_cone: VisionCone


func _ready():
	animated_sprite.play("startup")
	vision_cone.body_entered.connect(self._on_vision_body_entered)

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "startup":
		animated_sprite.play("running")

func _on_vision_body_entered(body: Node2D):
	if body is Ship && body != origin:
		var angle_to_ship: float = body.position.angle_to_point(position)
		velocity = velocity.rotated(angle_to_ship)
