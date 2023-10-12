extends Node

signal start_game()
signal quit_game()
signal enemy_manager_ready()

signal world_ready(world: World)
signal player_ready(player: Player)

signal enemy_destroyed(enemy: Enemy)
