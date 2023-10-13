class_name Ammo
extends RefCounted

var projectile_scene: PackedScene
var projectile_type: Projectile.ProjectileType
var projectile_count: int

var item_icon: Texture2D

func _init(icon: Texture2D, scene: PackedScene, type: Projectile.ProjectileType, count: int) -> void:
	self.item_icon = icon
	self.projectile_scene = scene
	self.projectile_type = type
	self.projectile_count = count

func consume_ammo():
	if projectile_count < 0:
		return
	projectile_count -= 1
