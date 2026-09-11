extends Node

enum GameState{
	READY,
	RUNNING,
	OVER
}

@export var mob_scene: PackedScene

var score: int
var game_state := GameState.READY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	game_state = GameState.OVER
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	# 开局两秒内死亡预防
	$StartTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game() -> void:
	score = 0
	game_state = GameState.RUNNING
	
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Music.play()
	
	get_tree().call_group("mobs", "queue_free")


func _on_mob_timer_timeout() -> void:
	var mob := mob_scene.instantiate()
	
	var mob_spawn_location := $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	# 動態計算無法自動推斷
	var direction: float = mob_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	if score % 10 == 0:
		$Player.add_health()


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_player_health_changed(health: int) -> void:
	$HUD.update_health(health)


func _on_hud_ui_game_ready() -> void:
	game_state = GameState.READY
