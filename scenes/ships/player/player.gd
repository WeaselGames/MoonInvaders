class_name Player
extends Ship

func _ready() -> void:
	super._ready()
	EventBus.player_ready.emit(self)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("spaceship_fire"):
		input.fire = true

	input.strafe = Input.get_axis("spaceship_strafe_left", "spaceship_strafe_right")
	input.thrust = Input.get_axis("spaceship_forward", "spaceship_backward")
	input.yaw = Input.get_axis("spaceship_rotate_left", "spaceship_rotate_right")
	input.weapons_up = Input.is_action_pressed("spaceship_weapons_up")
	input.weapons_down = Input.is_action_pressed("spaceship_weapons_down")

func pickup_item(item: Item) -> void:
	match item.item_type:
		item.ItemType.HEALTH:
			health += item.heal_amount
			if health > max_health:
				health = max_health
				
		item.ItemType.AMMO:
			ammo.append(item.get_ammo())

func ship_destroyed() -> void:
	EventBus.game_over.emit()
	queue_free()
