extends Area2D

signal hit
signal health_changed(health: int)

@export var speed := 400
var screem_size

# 防止同一物理帧的多重碰撞导致重复受伤
var is_invincible := false
# 逻辑状态，保留
var is_dead := false

var max_health := 3
var health := max_health


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
	if !is_invincible:
		health -= 1
		is_invincible = true
		if health <= 0:
			health = 0
			hide()
			hit.emit()
			# 延迟到物理帧结束后再修改碰撞状态，避免在碰撞回调中直接修改物理状态。
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			$CollisionShape2D.set_deferred("disabled", true)
			$InvincibleTimer.start()
			$BlinkTimer.start()
		health_changed.emit(health)


func start(pos: Vector2) -> void:
	position = pos
	
	health = max_health
	health_changed.emit(health)
	
	$InvincibleTimer.stop()
	is_invincible = false
	$CollisionShape2D.disabled = false
	
	$BlinkTimer.stop()
	$AnimatedSprite2D.self_modulate.a = 1.0
	show()


func _on_invincible_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$BlinkTimer.stop()
	$AnimatedSprite2D.self_modulate.a = 1.0
	is_invincible = false


func _on_blink_timer_timeout() -> void:
	if $AnimatedSprite2D.self_modulate.a == 1.0:
		$AnimatedSprite2D.self_modulate.a = 0.5
	elif $AnimatedSprite2D.self_modulate.a == 0.5:
		$AnimatedSprite2D.self_modulate.a = 1.0


func add_health() -> void:
	# 回血竞态
	if health > 0 and health < max_health:
		health += 1
		health_changed.emit(health)
