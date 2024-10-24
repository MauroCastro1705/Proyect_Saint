extends CharacterBody2D

signal hit
signal player_died

@export var speed = 200
@export var projectile_scene: PackedScene
@export var friction = 0.8  # Añadimos fricción para reducir el patinaje
@export var max_health = 3  # Vida máxima del jugador
var current_health: int
var is_shooting = false

func _ready():
	hide()
	add_to_group("player")
	current_health = max_health
	update_hud_health()
	$AnimatedSprite2D.play("Idle")  # Comienza con la animación Idle
	
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
		shoot()

func shoot():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		$AnimatedSprite2D.play("Shoot")
		# Añadir el proyectil al nivel principal, no al player
		get_parent().add_child(projectile)
		projectile.position = global_position + Vector2.RIGHT.rotated(rotation) * 20
		projectile.rotation = rotation
		await get_tree().create_timer(0.3).timeout
		$AnimatedSprite2D.play("Idle")

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	update_hud_health()
	
	
func take_damage(damage: int):
	current_health -= damage
	get_node("../HUD").update_health(current_health) 
	print("Player Health: ", current_health)  # Debug
	update_hud_health()
	hit.emit()  # Emitimos señal de golpe
	if current_health <= 0:
		die()
	else:
		# Opcional: añadir invulnerabilidad temporal
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(1.0).timeout  # 1 segundo de invulnerabilidad
		$CollisionShape2D.set_deferred("disabled", false)

func die():
	hide()
	player_died.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_body_entered(body):	
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func update_hud_health():
	var hud = get_node("../HUD")
	if hud:
		hud.update_health(current_health)
