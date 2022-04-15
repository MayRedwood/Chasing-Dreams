extends Node


# Declare member variables here. Examples:
export(PackedScene) var enemy
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Enemy.player = $Player
	randomize()
	__spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = str($Player.timer/(5*60))


func __spawn():
	while true:
		var x := randi() % 1025
		var y := randi() % 601
		var spawned = enemy.instance()
		spawned.position = Vector2(x, y)
		spawned.player = $Player
		add_child(spawned)
		yield(get_tree().create_timer(5.0), "timeout")
