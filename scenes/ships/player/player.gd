class_name Player
extends Ship

func _ready() -> void:
	super._ready()
	EventBus.player_ready.emit(self)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("spaceship_fire"):
			fire()
	movement_direction = Input.get_axis("spaceship_left", "spaceship_right")

func pickup_item(item: Item) -> void:
	match item.item_type:
		item.ItemType.HEALTH:
			health += item.heal_amount
			if health > max_health:
				health = max_health
