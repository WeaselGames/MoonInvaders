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
	var angle_to_player: float = find_player_angle()
	var angle_difference: float = angle_to_player - rotation
	if abs(angle_difference) > deg_to_rad(10):
		ai_state = EnemyAIState.AIM_AT_PLAYER

	match ai_state:
		EnemyAIState.MOVE_TO_PLAYER:
			var input_vector: Vector2 = Vector2(0, -1).rotated(angle_difference)
				
			thrust = input_vector.y
			strafe = input_vector.x
			
		
		EnemyAIState.AIM_AT_PLAYER:
			if abs(angle_difference) > deg_to_rad(1):
				if angle_difference > 1 && rotation < 0:
					yaw = -1
				elif angle_difference < -1 && rotation > 0:
					yaw = 1
				elif angle_difference > 0:
					yaw = 1
				else:
					yaw = -1
			
			if abs(angle_difference) < deg_to_rad(5):
				# Check if the player is within firing range
				if position.distance_to(_player.position) < 100:
					ai_state = EnemyAIState.FIRE_AT_PLAYER
				else:
					ai_state = EnemyAIState.MOVE_TO_PLAYER
		
		EnemyAIState.FIRE_AT_PLAYER:
			pass

func find_player_angle() -> float:
	var angle = position.angle_to_point(_player.position)
	angle += PI/2
	if angle > PI:
		angle -= PI*2
	return angle
