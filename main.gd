extends Node
@export var mob_scene: PackedScene
var score

func _ready() -> void:
	randomize()
	# Conectar señal de muerte del jugador
	$Player.player_died.connect(_on_player_player_died)	
	
func _process(_delta: float) -> void:
	pass
	
func game_over():
	$OtroTimer.stop() #va a cumplir otra funcion
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Player.current_health = $Player.max_health  # Resetear vida
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Player.show() #muestra jugador

	
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$OtroTimer.start() #otra funcion
	
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var player = $Player
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	mob.set_player(player)
	add_child(mob)
	mob.mob_killed.connect(_on_mob_killed)
	
func _on_mob_killed():  # sube score por mob muerto
	score += 1
	$HUD.update_score(score)
	
func _on_player_player_died():  # player died
	game_over()


func _on_otro_timer_timeout() -> void:
	pass # Replace with function body.
