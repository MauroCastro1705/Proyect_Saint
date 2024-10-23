extends CharacterBody2D

signal hit

@export var speed = 200
@export var projectile_scene: PackedScene
@export var friction = 0.8  # Añadimos fricción para reducir el patinaje

func _ready():
	hide()
	add_to_group("player")

func _physics_process(delta):
	# Input de movimiento
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_axis("ui_left", "ui_right")
	input_direction.y = Input.get_axis("ui_up", "ui_down")
	
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		# Aplicar aceleración gradual
		velocity = velocity.lerp(input_direction * speed, friction)
	else:
		# Aplicar fricción cuando no hay input
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	move_and_slide()
	
	# Rotación hacia el mouse
	look_at(get_global_mouse_position())

func _input(event):
	if event.is_action_pressed("shoot"):
		print("Shoot key pressed")  # Debug print
		shoot()

func shoot():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		# Añadir el proyectil al nivel principal, no al player
		get_parent().add_child(projectile)
		# Posicionar el proyectil en la punta del arma (si tienes un marcador)
		# Si tienes un marcador llamado "Muzz"
		# projectile.position = $Muzzle.global_position
		# Si no tienes un marcador, usa la posición del player más un offset en la dirección que mira
		projectile.position = global_position + Vector2.RIGHT.rotated(rotation) * 20
		projectile.rotation = rotation

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
