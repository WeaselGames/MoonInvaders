extends Camera2D

@export var speed := 5

var player: Player

func _ready():
	EventBus.world_ready.connect(self._on_world_ready)
	EventBus.player_ready.connect(self._on_player_ready)

func _on_world_ready(world: World):
#	limit_left = -int(world.size.x / 2.0)
#	limit_right = int(world.size.x / 2.0)
#	limit_top = -int(world.size.y / 2.0)
#	limit_bottom = int(world.size.y / 2.0)
	pass

func _on_player_ready(_player: Player):
	self.player = _player

func _physics_process(delta: float) -> void:
	if GameState.paused || player == null:
		return
	
	position = lerp(position, player.position, speed * delta)
