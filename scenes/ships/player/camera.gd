extends Camera2D

var player: Player

func _ready():
	EventBus.world_ready.connect(self._on_world_ready)
	EventBus.player_ready.connect(self._on_player_ready)
	get_viewport().size_changed.connect(update_position)
	set_process(false)

func _on_world_ready(world: World):
	limit_left = -int(world.size.x / 2.0)
	limit_right = int(world.size.x / 2.0)

func _on_player_ready(_player: Player):
	self.player = _player
	set_process(true)
	update_position()

func _physics_process(_delta: float) -> void:
	if GameState.paused:
		return

	update_position()

func update_position():
	if player == null:
		return
	
	var viewport_size = get_viewport_rect().size
	position.y = (player.position.y - (viewport_size.y/2)) + ((player.size.y*2) + 150)
	position.x = player.position.x
	
