extends Node2D

@export var enemy_scene : PackedScene
@export var enemy_create_timer : Timer # enery_timer的作用是控制global_timer, 相当于一个桥梁变量

@export var score : int = 0     # 史莱姆击杀时+1, 逻辑在enemy.gd里
@export var score_label : Label # 和CanvasLayer下的ScoreLabel关联
@export var gameover_label : Label # 和CanvasLayer下的GameOverLabel关联

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameover_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_create_timer.wait_time -= 0.2 * delta # 等价每秒-0.2秒
	enemy_create_timer.wait_time = clamp(enemy_create_timer.wait_time, 1, 3) # 控制下min/max
	score_label.text = 'Score: ' + str(score)


# 这里用来管理史莱姆的生成
func _on_timer_timeout() -> void:
	var slime_node = enemy_scene.instantiate()
	slime_node.position = slime_node.position + Vector2(650, randf_range(0, 300))
	get_tree().current_scene.add_child(slime_node) # 其实这里可以直接add_child(slime_node), 因为当前就是root
	

func show_gameover():
	gameover_label.visible = true	
