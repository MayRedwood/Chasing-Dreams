extends Node


# Declare member variables here. Examples:
export(PackedScene) var enemy_l1
export(PackedScene) var enemy_l2
export(PackedScene) var enemy_l3
var enemy
export(Resource) var bullet_kit
export(Resource) var non_collison_kit
export(Resource) var theme
var counter := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Player.modulate = Global.DARK_PURPLE
	#bullet_kit.material.set_shader_param("modulate", Global.LIGHT_PURPLE)
	#non_collison_kit.material.set_shader_param("modulate", Global.DESATURATED_ROSE)
	#$ColorRect.color = Global.VIBRANT_ROSE
	#theme.set_color("font_color", "Label", Global.DARK_PURPLE)
	#$Enemy.player = $Player
	randomize()
	enemy = enemy_l1
	__spawn()
	Global.score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/Label.text = str($Player.timer/120)
	if Global.score > 4000:
		$CanvasLayer/Label2.text = "REM Sleep"
	elif Global.score > 1500:
		$CanvasLayer/Label2.text = "N3"
		enemy = enemy_l3
	elif Global.score > 400:
		$CanvasLayer/Label2.text = "N2"
		enemy = enemy_l2
	else:
		$CanvasLayer/Label2.text = "N1"
		enemy = enemy_l1
	$CanvasLayer/Label3.text = str(Global.high_score)


func __spawn():
	while is_inside_tree():
		var x := randi() % 1025
		var y := randi() % 601
		var spawned = enemy.instance()
		add_child(spawned)
		var goal = Vector2(x, y)
		spawned.position = spawn_offscreen(goal)
		spawned.get_node("Tween").interpolate_property(
				spawned, "position", spawned.position, goal, 3.0, 1
		)
		spawned.get_node("Tween").start()
		spawned.player = $Player
		counter += 1
		yield(get_tree().create_timer(counter/2), "timeout")


func spawn_offscreen(goal: Vector2):
	var m: int = 0
	var a: int = 1024
	var n: int = 0
	var b: int = 600
	if goal.x < 1024/4:
		m = -420
		a = 400
	elif goal.x > 3*1024/4:
		m = 1044
		a = 400
	elif goal.y < 600/2:
		n = -220
		b = 200
	else:
		n = 620
		b = 200
	return Vector2((randi() % a) + m, (randi() % b) + n)
