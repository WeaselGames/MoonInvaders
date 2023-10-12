extends Node

var paused: bool = false

var world: World
var player: Player

func _ready():
	EventBus.world_ready.connect(self._world_ready)
	EventBus.player_ready.connect(self._player_ready)

func _world_ready(_world: World):
	self.world = _world

func _player_ready(_player: Player):
	self.player = _player
