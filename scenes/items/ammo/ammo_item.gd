class_name AmmoItem
extends Item

@export var projectile_scene: PackedScene
@export var projectile_type: Projectile.ProjectileType
@export var projectile_count: int

func get_ammo() -> Ammo:
	return Ammo.new(item_icon, projectile_scene, projectile_type, projectile_count)
