class_name Enemy
extends Ship

var ai: EnemyAI

func _ready():
	super._ready()
	ai = EnemyAI.new(self)
	input = ai.get_input()

func _process(delta: float) -> void:
	super._process(delta)
	ai.update()

func ship_destroyed() -> void:
	EventBus.enemy_destroyed.emit(self)
