extends CanvasLayer

signal start_game
signal ui_game_ready

var message_was_visible := false

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
	ui_game_ready.emit()


func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func update_health(health: int) -> void:
	$HealthLabel.text = "HP:" + str(health)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PausedLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


# 暂停时处理，禁止启动按钮互动，防信号发送
func set_paused(paused: bool) -> void:
	$StartButton.disabled = paused
	
	# 暂停可视化
	if paused:
		message_was_visible = $Message.visible
		$Message.hide()
		$PausedLabel.show()
	else:
		$PausedLabel.hide()
		if message_was_visible:
			$Message.show()
