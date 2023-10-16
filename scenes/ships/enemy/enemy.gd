class_name Enemy
extends Ship

@export var vision_cone: VisionCone
@export var attack_cooldown: float = 1
@export var patrol_distance: int = 250

enum EnemyAIState { PATROL, SEARCH, ATTACK_PLAYER }
var ai_state: EnemyAIState = EnemyAIState.PATROL

var _world: World
var _player: Player
var _home: Vector2

var patrol_point: Vector2
var patrol_home_set: bool
var patrol_point_set: bool

var search_point_of_interest: Vector2
var search_looking_around: bool
var search_original_rotation: float
var search_halfway: bool
var search_direction: int

var attack_cooldown_timer: Timer

func _ship_ready() -> void:
	_world = GameState.world
	if _world == null:
		_world = await EventBus.world_ready
	_player = GameState.player
	if _player == null:
		_player = await EventBus.player_ready
	
	_home = position
	vision_cone.body_entered.connect(self._on_vision_cone_body_enter)
	vision_cone.body_exited.connect(self._on_vision_cone_body_exited)
	
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.one_shot = true
	add_child(attack_cooldown_timer)

func _on_vision_cone_body_enter(body: Node2D):
	if body is Player:
		ai_state = EnemyAIState.ATTACK_PLAYER

func _on_vision_cone_body_exited(body: Node2D):
	if body is Player:
		ai_state = EnemyAIState.SEARCH
		search_point_of_interest = body.position
		search_looking_around = false

func ship_destroyed() -> void:
	EventBus.enemy_destroyed.emit(self)
	queue_free()

func damage_from(origin: Vector2) -> void:
	if ai_state == EnemyAIState.PATROL || ai_state == EnemyAIState.SEARCH:
		ai_state = EnemyAIState.SEARCH
		search_point_of_interest = origin
		search_looking_around = false

func update_input():
	if GameState.paused:
		return

	# all input values are floats from -1 to 1
	yaw = 0
	thrust = 0
	strafe = 0
	
	match ai_state:
		EnemyAIState.PATROL:
			if abs(position.distance_to(_home)) > 250 && !patrol_home_set:
				patrol_point = _home
				patrol_home_set = true
				patrol_point_set = false
			elif abs(position.distance_to(_home)) < 2 && !patrol_point_set:
				var dir: int = randi_range(0, 3)
				match dir:
					0:
						patrol_point = Vector2(_home.x + patrol_distance, _home.y)
					1:
						patrol_point = Vector2(_home.x - patrol_distance, _home.y)
					2:
						patrol_point = Vector2(_home.x, _home.y + patrol_distance)
					3:
						patrol_point = Vector2(_home.x, _home.y - patrol_distance)
				
				patrol_point_set = true
				patrol_home_set = false
			
			var patrol_angle: float = position.angle_to_point(patrol_point)
			aim_at(patrol_angle)
			thrust_towards(patrol_angle)
		
		EnemyAIState.SEARCH:
			var poi_angle: float = position.angle_to_point(search_point_of_interest)
			var poi_distance: float = abs(position.distance_to(search_point_of_interest))
			
			if poi_distance > 1:
				thrust_towards(poi_angle)
				aim_at(poi_angle)
			else:
				if !search_looking_around:
					search_original_rotation = rotation
					search_looking_around = true
					search_halfway = false
					search_direction = randi_range(0, 1)
					if search_direction == 0: search_direction = -1
				elif abs(rotation-(search_original_rotation * -1)) > deg_to_rad(2) && !search_halfway:
					yaw = search_direction
				elif abs(rotation-(search_original_rotation * -1)) < deg_to_rad(2) && !search_halfway:
					yaw = search_direction
					search_halfway = true
				elif abs(rotation-search_original_rotation) > deg_to_rad(2) && search_halfway:
					yaw = search_direction
				elif abs(rotation-search_original_rotation) < deg_to_rad(2) && search_halfway:
					ai_state = EnemyAIState.PATROL
					search_looking_around = false
					
		EnemyAIState.ATTACK_PLAYER:
			var player_angle: float = get_player_angle()
			var player_distance: float = abs(position.distance_to(_player.position))
			if player_distance > 100:
				thrust_towards(player_angle, 0.5)
			aim_at(player_angle)
			if attack_cooldown_timer.time_left == 0 && abs(player_angle - rotation) < deg_to_rad(2):
				fire()
				attack_cooldown_timer.start(attack_cooldown)

func get_player_angle() -> float:
	return position.angle_to_point(_player.position)

func thrust_towards(angle: float, by: float = 1) -> void:
		var input_vector: Vector2 = Vector2(by, 0).rotated(angle - rotation)
		thrust = input_vector.x

func aim_at(angle: float) -> void:
	var angle_diff: float = angle - rotation
	if abs(angle_diff) > deg_to_rad(2):
		yaw = find_fastest_yaw(angle_diff)

func find_fastest_yaw(angle_diff: float) -> float:
	if angle_diff > 0 && angle_diff < PI:
		return 1
	elif angle_diff > 0 && angle_diff > PI:
		return -1
	elif angle_diff < 0 && angle_diff > -PI:
		return -1
	elif angle_diff < 0 && angle_diff < -PI:
		return 1
	else:
		return 0
