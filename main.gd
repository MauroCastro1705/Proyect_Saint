extends Node
@export var mob_scene: PackedScene
var score
func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Player.show() #muestra jugador
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var player = $Player
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	mob.set_player(player)
	add_child(mob)
