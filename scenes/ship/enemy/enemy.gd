class_name Enemy
extends Ship

func _ready() -> void:
	$BulletCooldown.start(bullet_cooldown*0.001)
	movement_direction = randi_range(-1, 1)

func _on_direction_change_timeout() -> void:
	movement_direction = randi_range(-1, 1)

func _on_bullet_cooldown_timeout() -> void:
	fire()
