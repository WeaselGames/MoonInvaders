class_name Player
extends Ship

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("spaceship_fire"):
			fire()
	movement_direction = Input.get_axis("spaceship_left", "spaceship_right")

