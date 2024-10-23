extends RigidBody2D

var speed = 100
var health = 3
var player = null

func _ready():
	add_to_group("mobs")  # Cambiado a "mobs" para coincidir con el main.gd
	gravity_scale = 0
	contact_monitor = true
	max_contacts_reported = 4
	linear_damp = 5

func set_player(target):
	player = target

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		linear_velocity = direction * speed

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
