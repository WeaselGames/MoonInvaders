class_name EnemyAI
extends RefCounted

var enemy: Enemy
var input: Ship.ShipInput

func _init(_enemy: Enemy) -> void:
	input = Ship.ShipInput.new()
	enemy = _enemy

func get_input() -> Ship.ShipInput:
	return input

func update() -> void:
	input.thrust = 1
	input.strafe = 1
	input.fire = true
