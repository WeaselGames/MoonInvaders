class_name HealthBar
extends ColorRect

var shader: ShaderMaterial

@export var color_from: Color = Color.RED
@export var color_to: Color = Color.GREEN
@export var color_bg: Color = Color.BLACK

func _ready():
	shader = material.duplicate()
	material = shader
	shader.set_shader_parameter("progress", 1.0)
	shader.set_shader_parameter("color_from", color_from)
	shader.set_shader_parameter("color_to", color_to)
	shader.set_shader_parameter("color_bg", color_bg)
	shader.set_shader_parameter("progress", 1.0)


func update(current_health, max_health) -> void:
	var percentage := float(current_health) / float(max_health) if current_health != 0 else 0.0
	shader.set_shader_parameter("progress", percentage)

