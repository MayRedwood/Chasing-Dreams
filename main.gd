extends Node


# Declare member variables here. Examples:
export(PackedScene) var enemy
var counter := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Enemy.player = $Player
	randomize()
	__spawn()
	Global.score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/Label.text = str($Player.timer/(5*60))
	if Global.score > 3000:
		$CanvasLayer/Label2.text = "REM Sleep"
	elif Global.score > 2000:
		$CanvasLayer/Label2.text = "N3"
	elif Global.score > 1000:
		$CanvasLayer/Label2.text = "N2"
	else:
		$CanvasLayer/Label2.text = "N1"
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
