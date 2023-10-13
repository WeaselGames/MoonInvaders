extends Node

enum Menu { MAIN, INGAME, PAUSE, GAMEOVER }
var current_menu = Menu.MAIN

var menus: Dictionary
var previous_menu = Menu.MAIN

func set_canvas_layer(canvas_layer: CanvasLayer) -> void:
	for menu in canvas_layer.menus.get_children():
		menus[menu.menu_type] = menu as MenuPanel

func change_menu(new_menu: Menu) -> void:
	previous_menu = current_menu
	current_menu = new_menu
	menus[previous_menu].hide()
	menus[current_menu].show()
	if menus[current_menu].is_paused:
		GameState.pause_game()
	else:
		GameState.resume_game()

func revert_menu() -> void:
	change_menu(previous_menu)

func get_current_menu() -> MenuPanel:
	return menus[current_menu]
