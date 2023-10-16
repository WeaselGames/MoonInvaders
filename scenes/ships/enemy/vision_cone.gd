@tool

class_name VisionCone
extends Area2D

@export var width: int :
		set(value):
			width = value
			change_size()

@export var height: int :
		set(value):
			height = value
			change_size()

@export var peripheral_radious: int :
		set(value):
			peripheral_radious = value
			change_size()

@export var peripheral_indicator_points: int :
		set(value):
			peripheral_indicator_points = value
			change_size()

@export var collision_polygon: CollisionPolygon2D :
		set(value):
			collision_polygon = value
			change_size()

@export var collision_shape: CollisionShape2D :
		set(value):
			collision_shape = value
			change_size()

@export var color: Color = Color(1, 1, 1, 0.5) :
		set(value):
			color = value
			queue_redraw()

func _ready() -> void:
	change_size()

func change_size() -> void:
	if collision_polygon == null:
		return

	collision_polygon.polygon = [
		Vector2(0, 0),
		Vector2(height, width / 2.0),
		Vector2(height, -(width / 2.0)),
	]
	
	if collision_shape == null:
		return
	
	collision_shape.shape.radius = peripheral_radious
	
	queue_redraw()

func _draw() -> void:
	draw_line(Vector2(0, 0), Vector2(height, width / 2.0), color, -1)
	draw_line(Vector2(0, 0), Vector2(height, -(width / 2.0)), color, -1)
	draw_line(Vector2(height, width / 2.0), Vector2(height, -(width / 2.0)), color, -1)
	draw_arc(Vector2(0, 0), peripheral_radious, 0, TAU, peripheral_indicator_points, color)
