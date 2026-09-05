extends CanvasLayer

signal start_game


func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Game Over!")
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

# 暂停功能bug，待修理
#func show_game_paused(paused: bool) -> void:
	#show_message("Game Paused!")
	#await $MessageTimer.timeout


func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func update_health(health: int) -> void:
	$HealthLabel.text = "HP:" + str(health)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
