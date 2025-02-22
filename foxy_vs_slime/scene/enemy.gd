extends Area2D


@export var slime_speed : float = 50

var is_death : bool = false

# 每帧都会调用该函数
func _physics_process(delta: float) -> void:
	if not is_death:
		position += Vector2(-slime_speed, 0) * delta
	if position.x < -660: # -660为左边界, 到边界了就自动释放
		queue_free()


# body碰撞信号的slot
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_death:
		body.game_over()
		

# area碰撞信号的slot
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('bullet') and is_death == false: # 史莱姆与子弹碰撞
		is_death = true
		area.queue_free() # 子弹消失
		$slime.play("ide") # 死亡动画
		$SlimeDeathSound.play()
		get_tree().current_scene.score += 1 # gameMgr定义了score
		await get_tree().create_timer(0.6).timeout
		queue_free() # 史莱姆消失
