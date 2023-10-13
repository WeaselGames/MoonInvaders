extends AmmoItem

func get_ammo() -> Ammo:
	var ammo = Ammo.new(item_icon, projectile_scene, projectile_type, projectile_count)
	return ammo
