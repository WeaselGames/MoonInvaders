extends MenuPanel

func _on_play_pressed() -> void:
	EventBus.start_game.emit()
