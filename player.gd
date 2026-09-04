extends Area2D

signal hit

@export var speed := 400
var screem_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screem_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vlocity := Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		vlocity.x -= 1
	if Input.is_action_pressed("move_right"):
		vlocity.x += 1
	if Input.is_action_pressed("move_down"):
		vlocity.y += 1
	if Input.is_action_pressed("move_up"):
		vlocity.y -= 1
	
	if vlocity.length() > 0:
		vlocity = vlocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += vlocity * delta
	position = position.clamp(Vector2.ZERO, screem_size)
	
	if vlocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = vlocity.x < 0
	elif vlocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = vlocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
