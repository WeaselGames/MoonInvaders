class_name Enemy
extends Ship

var direction_change_timer: Timer

func _ready() -> void:
	super._ready()
	projectile_cooldown_timer.start(projectile_cooldown*0.001)
	projectile_cooldown_timer.timeout.connect(self._on_projectile_cooldown_timeout)
	movement_direction = randi_range(-1, 1)
	
	direction_change_timer = Timer.new() 
	add_child(direction_change_timer)
	direction_change_timer.timeout.connect(self._on_direction_change_timeout)
	direction_change_timer.one_shot = false
	direction_change_timer.wait_time = 1.0
	direction_change_timer.start()

func _on_direction_change_timeout() -> void:
	if GameState.paused:
		return

	movement_direction = randi_range(-1, 1)

func _on_projectile_cooldown_timeout() -> void:
	if GameState.paused:
		return
	
	fire()

func ship_destroyed() -> void:
	EventBus.enemy_destroyed.emit(self)
