extends CanvasLayer
# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$Message2.text = text
	$Message2.show()
	$MessageTimer2.start()
	
func update_health(health: int):
	$HealthLabel.text = "Health: " + str(health)
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer2.timeout

	$Message2.text = "Dodge the Creeps!"
	$Message2.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton2.show()

func update_score(score):
	$ScoreLabel2.text = str(score)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#conectada
func _on_start_button_2_pressed() -> void:
		$StartButton2.hide()
		start_game.emit()
#conectada
func _on_message_timer_2_timeout() -> void:
	$Message2.hide()
