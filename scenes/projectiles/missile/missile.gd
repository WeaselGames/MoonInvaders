class_name Missile
extends Projectile

@export var animated_sprite: AnimatedSprite2D

func _ready():
	animated_sprite.play("startup")


func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "startup":
		animated_sprite.play("running")
