extends Camera2D

@export var scroll_speed = 20

#Scroll camera up Y for background at constant rate
func _physics_process(delta: float) -> void:
	position.y -= scroll_speed * delta
