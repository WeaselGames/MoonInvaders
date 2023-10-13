extends MenuPanel

func _ready():
	if is_visible():
		self.hide()

func _on_resume_pressed() -> void:
	UI.change_menu(UI.Menu.INGAME)

func _on_quit_pressed() -> void:
	EventBus.quit_game.emit()

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if GameState.paused:
			UI.change_menu(UI.Menu.INGAME)
		else:
			UI.change_menu(UI.Menu.PAUSE)
