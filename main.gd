extends Node


# Declare member variables here. Examples:
export(PackedScene) var enemy
var counter := 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Enemy.player = $Player
	randomize()
	__spawn()
	Global.score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/Label.text = str($Player.timer/(5*60))
	$CanvasLayer/Label2.text = str(Global.score)
	$CanvasLayer/Label3.text = str(Global.high_score)


func __spawn():
	while is_inside_tree():
		var x := randi() % 1025
		var y := randi() % 601
		var spawned = enemy.instance()
		spawned.position = Vector2(x, y)
		spawned.player = $Player
		add_child(spawned)
		counter += 1
		yield(get_tree().create_timer(counter/2), "timeout")
