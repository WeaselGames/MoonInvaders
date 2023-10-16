extends Camera2D

@export var speed := 5

var player: Player

func _ready():
	EventBus.player_ready.connect(self._on_player_ready)

func _on_player_ready(_player: Player):
	self.player = _player

func _physics_process(delta: float) -> void:
	if GameState.paused || player == null:
		return
	
	position = lerp(position, player.position, speed * delta)
