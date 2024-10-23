extends RigidBody2D

@export var speed = 400
@export var damage = 1

func _ready():
	add_to_group("projectiles")
	# Configuraciones importantes para el proyectil
	gravity_scale = 0
	contact_monitor = true
	max_contacts_reported = 4
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY # Mejora la detección de colisiones a alta velocidad

func _physics_process(delta):
	# El proyectil mantiene su velocidad lineal constante
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

func _on_body_entered(body):
	if body.is_in_group("mobs") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
	elif not body.is_in_group("player"): # No destruir si golpea al jugador
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
