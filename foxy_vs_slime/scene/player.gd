extends CharacterBody2D

@export var move_speed : float = 50
@export var fox : AnimatedSprite2D
@export var bullet_scence : PackedScene

@export var is_game_over = false

# 初次加载时调用
func _ready() -> void:
	pass
	
# 每帧都会调用该函数, 跟物理模拟无关的用_process
func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$runSound.stop()
	elif not $runSound.playing:
		$runSound.play()


# 每帧都会调用该函数, 跟物理模拟相关的用_physics_process
func _physics_process(delta: float) -> void:
	if is_game_over == false:
		# 速度向量velocity一般配合move_and_slide(); 这套效果或许也可以通过position来实现?
		velocity = Input.get_vector("left", "right", "up", "down") * move_speed # 这个乘法是Vector2的运算符重载
		if velocity == Vector2.ZERO:
			fox.play("idle")
		else:
			fox.play("run")
		move_and_slide() # 根据当前velocity移动物体, 直至下一次move_and_slide(); (该函数是在改变一种状态, 而不是产生一次位移)
	

func game_over():
	if not is_game_over:
		get_tree().current_scene.show_gameover()
		is_game_over = true
		$gameoverSound.play()
		fox.play('die')
		$RestartTimer.start() # 停2s后重置主场景


# FireTimer的timeout slot
func _on_fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:
		return
	$fireSound.play()
	var bullet_node = bullet_scence.instantiate()
	bullet_node.position = position + Vector2(30, 20)
	get_tree().current_scene.add_child(bullet_node) # current_scene就是主场景节点(即root的子节点main)

# RestartTimer的timeout slot
func _on_restart() -> void:
	get_tree().reload_current_scene() # current_scene就是主场景节点(即root的子节点main)
