extends Node

signal paused_changed(paused: bool)

# 暂停bug，待修
#func _input(event) -> void:
	#if event.is_action_pressed("paused_process"):
		#get_tree().paused = not get_tree().paused
		#paused_changed.emit(get_tree().paused)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
