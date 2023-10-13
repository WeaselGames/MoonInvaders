extends MenuPanel

func _on_quit_pressed() -> void:
	EventBus.quit_game.emit()

func _on_play_again_pressed() -> void:
	EventBus.reset_game.emit()
