extends Node

signal paused_changed(paused: bool)


func _input(event: InputEvent) -> void:
	# 防回显事件长按持续触发
	if event.is_action_pressed("paused_process") and not event.is_echo():
		# 让输入停止沿场景树传播，防重复输入
		get_viewport().set_input_as_handled()
		get_tree().paused = not get_tree().paused
		paused_changed.emit(get_tree().paused)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
