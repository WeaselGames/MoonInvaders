extends Node

var paused: bool = false

var world: World
var player: Player

var game_seed: int = 0

func _ready():
	EventBus.world_ready.connect(self._world_ready)
	EventBus.player_ready.connect(self._player_ready)

func _world_ready(_world: World):
	self.world = _world

func _player_ready(_player: Player):
	self.player = _player
	game_seed = Time.get_ticks_usec()

func pause_game() -> void:
	paused = true

func resume_game() -> void:
	paused = false
