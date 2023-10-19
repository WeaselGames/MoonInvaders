class_name Player
extends Ship

func _ship_ready() -> void:
	EventBus.player_ready.emit(self)

func update_input() -> void:
	if Input.is_action_pressed("spaceship_fire"):
		weapons_fire = true

	strafe = Input.get_axis("spaceship_strafe_left", "spaceship_strafe_right")
	thrust = Input.get_axis("spaceship_backward", "spaceship_forward")
	yaw = Input.get_axis("spaceship_rotate_left", "spaceship_rotate_right")
	weapons_up = Input.is_action_just_pressed("spaceship_weapons_up")
	weapons_down = Input.is_action_just_pressed("spaceship_weapons_down")

func pickup_item(item: Item) -> void:
	match item.item_type:
		item.ItemType.HEALTH:
			health += item.heal_amount
			if health > max_health:
				health = max_health
				
		item.ItemType.AMMO:
			var pickuped_ammo: Ammo = item.get_ammo()
			for stored_ammo in ammo:
				if stored_ammo.projectile_type == pickuped_ammo.projectile_type && stored_ammo.projectile_scene == pickuped_ammo.projectile_scene:
					stored_ammo.projectile_count += pickuped_ammo.projectile_count
					return
					
			ammo.append(pickuped_ammo)

func ship_destroyed() -> void:
	EventBus.game_over.emit()
	queue_free()
