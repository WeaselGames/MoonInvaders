extends Node

@onready var canvas_layer = preload("res://scenes/ui/canvas_layer.tscn").instantiate()

enum Menu { MAIN, INGAME, PAUSE }
var current_menu = Menu.MAIN

var _menus: Dictionary
var previous_menu = Menu.MAIN

func _ready() -> void:
	add_child(canvas_layer)
	for menu in canvas_layer.menus.get_children():
		_menus[menu.menu_type] = menu as MenuPanel

func change_menu(new_menu: Menu) -> void:
	previous_menu = current_menu
	current_menu = new_menu
	_menus[previous_menu].hide()
	_menus[current_menu].show()
	if _menus[current_menu].is_paused:
		GameManager.pause_game()
	else:
		GameManager.resume_game()

func revert_menu() -> void:
	change_menu(previous_menu)

func get_current_menu() -> MenuPanel:
	return _menus[current_menu]
