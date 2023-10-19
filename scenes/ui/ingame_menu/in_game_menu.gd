extends MenuPanel

@export var weapon_status: TextureRect
@export var ammo_count: Label

var progress_last: float = 1.0

var cooldown: float = 0.0
var cooldown_timer: Timer

var player: Player
var current_ammo: Ammo
var last_count: int

var weapon_shader: ShaderMaterial 

func _ready():
	EventBus.player_ready.connect(self._on_player_ready)
	weapon_shader = weapon_status.material
	weapon_shader.set_shader_parameter("progress", 0.0)

func _on_player_ready(_player: Player) -> void:
	player = _player
	player.weapon_fired.connect(self._on_player_weapon_fired)
	player.ammo_changed.connect(self._on_player_ammo_changed)
	var ammo: Ammo = player.ammo[player.ammo_index]
	current_ammo = ammo
	weapon_status.texture = ammo.item_icon
	update_ammo_count(ammo)

func _on_player_weapon_fired(ammo: Ammo, _cooldown: float, _cooldown_timer: Timer) -> void:
	cooldown_timer = _cooldown_timer
	cooldown = _cooldown
	current_ammo = ammo
	update_ammo_count(ammo)

func _on_player_ammo_changed(ammo: Ammo):
	weapon_status.texture = ammo.item_icon
	current_ammo = ammo
	update_ammo_count(ammo)

func _process(_delta: float) -> void:
	var progress: float = get_progress()
	if progress != progress_last:
		weapon_shader.set_shader_parameter("progress", progress)
		progress_last = progress
	
	if current_ammo != null && last_count != current_ammo.projectile_count:
		update_ammo_count(current_ammo)

func update_ammo_count(ammo: Ammo) -> void:
	last_count = ammo.projectile_count
	if ammo.projectile_count < 0:
		ammo_count.text = "INF"
	else:	
		ammo_count.text = "%03d" % ammo.projectile_count

func get_progress() -> float:
	if cooldown == 0 || cooldown_timer == null || cooldown_timer.time_left == 0:
		return 0.0
	return cooldown_timer.time_left/cooldown
