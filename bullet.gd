extends Area2D

var bullet_speed: int = 600


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.UP * delta * bullet_speed

func receive_player_muzzle_position(pos: Vector2) -> void:
	position = pos


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
