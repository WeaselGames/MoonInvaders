class_name Hardpoint
extends Node2D

@export var hardpoint_type: Projectile.ProjectileType

func fire(ship: Ship) -> float:
	if GameState.paused or GameState.world == null:
		return 0
	
	var projectile : Projectile = ship.ammo[ship.ammo_index].projectile_scene.instantiate()
	if projectile.projectile_type != hardpoint_type:
		return 0
	
	projectile.origin = ship
	GameState.world.add_object(projectile)
	return projectile.cooldown*0.01
