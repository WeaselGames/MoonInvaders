class_name Enemy
extends Ship

var _world: World
var _player: Player

enum EnemyAIState { MOVE_TO_PLAYER, AIM_AT_PLAYER, FIRE_AT_PLAYER }
var ai_state: EnemyAIState = EnemyAIState.MOVE_TO_PLAYER

func _ship_ready() -> void:
	_world = GameState.world
	if _world == null:
		_world = await EventBus.world_ready
	_player = GameState.player
	if _player == null:
		_player = await EventBus.player_ready

func ship_destroyed() -> void:
	EventBus.enemy_destroyed.emit(self)

func update_input():
	# all input values are floats from -1 to 1
	yaw = 0
	thrust = 0
	strafe = 0
	
	#var target_yaw: float = position.angle_to(_player.position)
	var target_yaw: float = find_angle()
	var angle_difference: float = target_yaw - rotation
	if abs(angle_difference) > deg_to_rad(1):
		ai_state = EnemyAIState.AIM_AT_PLAYER

	match ai_state:
		EnemyAIState.MOVE_TO_PLAYER:
			if abs(angle_difference) > deg_to_rad(1):
				ai_state = EnemyAIState.AIM_AT_PLAYER
		
		EnemyAIState.AIM_AT_PLAYER:
			if abs(angle_difference) > deg_to_rad(1):
				# Rotate towards the player
				if angle_difference > 0:
					yaw = 1
				else:
					yaw = -1
			
			if abs(angle_difference) < deg_to_rad(1):
				# Check if the player is within firing range
				if position.distance_to(_player.position) < 100:
					ai_state = EnemyAIState.FIRE_AT_PLAYER
				else:
					ai_state = EnemyAIState.MOVE_TO_PLAYER
		
		EnemyAIState.FIRE_AT_PLAYER:
			if abs(angle_difference) > deg_to_rad(1):
				ai_state = EnemyAIState.AIM_AT_PLAYER

# Finds angle between enemy and player
func find_angle():
	var delX: float = _player.position.x - position.x
	var delY: float = _player.position.y - position.y
	var modifier: float = 0
	if delY > 0 and delX < 0:
		print(rad_to_deg(-atan(delX / delY) - PI))
		return -atan(delX / delY) - PI
	elif delY < 0:
		return -atan(delX / delY)
	else:
		return -atan(delX / delY) + PI
