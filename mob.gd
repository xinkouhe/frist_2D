class_name Mob

extends RigidBody2D

signal mob_died

var is_dying := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types := Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func take_damage():
	if is_dying:
		return
	is_dying = true
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	mob_died.emit()
	queue_free()
