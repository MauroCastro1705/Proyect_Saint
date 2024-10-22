extends RigidBody2D

var player : Node2D  # El jugador que el mob seguirá
var speed = 20  # Velocidad del mob

func _physics_process(_delta):
	if player:
		# Calcular la dirección hacia el jugador
		var direction = (player.position - position).normalized()

		# Aplicar una velocidad constante hacia el jugador
		linear_velocity = direction * speed

		# Apuntar hacia el jugador
		look_at(player.position)

# Método para asignar el jugador al mob
func set_player(player_ref):
	player = player_ref
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
