extends Node


# Declare member variables here. Examples:
export(PackedScene) var enemy_l0
export(PackedScene) var enemy_l1
export(PackedScene) var enemy_l2
export(PackedScene) var enemy_l3
export(PackedScene) var enemy_l4
var enemy
var doremy_started := false
var doremy_active := false
var end_started := false
export(Resource) var bullet_kit
export(Resource) var non_collison_kit
export(Resource) var theme


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Player.modulate = Global.DARK_PURPLE
	#bullet_kit.material.set_shader_param("modulate", Global.LIGHT_PURPLE)
	#non_collison_kit.material.set_shader_param("modulate", Global.DESATURATED_ROSE)
	#$ColorRect.color = Global.VIBRANT_ROSE
	#theme.set_color("font_color", "Label", Global.DARK_PURPLE)
	#$Enemy.player = $Player
	Global.score = 0
	Global.counter = 0.0
	Global.deaths += 1
	process_dialog()
	#start()


func process_dialog():
	#yield(get_tree().create_timer(0.5), "timeout")
	var string = Global.choose_dialogs()
	#Global.save_files()
	if string != "":
		$Tween.interpolate_property(
			Music, "volume_db", Music.volume_db, -80, 2.0, 1
		)
		$Tween.start()
		var dialogue = Dialogic.start(string)
		add_child(dialogue)
	else:
		start()


func start():
	$Tween.interpolate_property(
			$CanvasLayer/ColorRect2, "color", $CanvasLayer/ColorRect2.modulate, Color("#00000000"), 1.0, 1
	)
	$Tween.interpolate_property(
			Music, "volume_db", Music.volume_db, -5, 2.0, 1
	)
	$Tween.start()
	randomize()
	enemy = enemy_l1
	if Global.tutorial_done:
		__spawn()
	else:
		spawn_tutorial_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/Label.text = str(Global.counter)
	if Global.score > 7000:
		$CanvasLayer/Label2.text = ""
		if Global.four and not end_started:
			end()
	elif Global.score > 4000:
		$CanvasLayer/Label2.text = "REM Sleep"
		if (not doremy_started) and Global.four:
			doremy_dialog()
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
	while is_inside_tree() and not doremy_active:
		spawn_enemy(enemy)
		if Global.counter > 0:
			yield(get_tree().create_timer(Global.counter/2), "timeout")


func spawn_enemy(enem):
	var x := randi() % 1025
	var y := randi() % 601
	var spawned = enem.instance()
	add_child(spawned)
	var goal = Vector2(x, y)
	spawned.position = spawn_offscreen(goal)
	spawned.get_node("Tween").interpolate_property(
			spawned, "position", spawned.position, goal, 3.0, 1
	)
	spawned.get_node("Tween").start()
	spawned.player = $Player
	if spawned is L4Enemy:
		Global.counter = 1.3
	else:
		Global.counter += 1


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


func spawn_tutorial_enemy():
	var x := randi() % 1025
	var y := randi() % 601
	var spawned = enemy_l0.instance()
	add_child(spawned)
	var goal = Vector2(x, y)
	spawned.position = spawn_offscreen(goal)
	spawned.get_node("Tween").interpolate_property(
			spawned, "position", spawned.position, goal, 3.0, 1
	)
	spawned.get_node("Tween").start()
	spawned.player = $Player
	spawned.look_at_player = true
	Global.counter += 1
	yield(spawned, "tree_exited")
	Global.tutorial_done = true
	__spawn()


func doremy_dialog():
	for node in get_tree().get_nodes_in_group("enemies"):
		node.die()
	doremy_active = true
	doremy_started = true
	yield(get_tree().create_timer(2.0), "timeout")
	var doremy_dialog = Dialogic.start("Doremy" + str(Global.doremy_counter))
	add_child(doremy_dialog)
	if Global.doremy_counter < 4:
		Global.doremy_counter += 1


func despawn_doremy():
	doremy_active = false
	enemy = enemy_l4
	__spawn()


func end():
	$Player.grasping = true
	for node in get_tree().get_nodes_in_group("enemies"):
		node.die()
	end_started = true
	doremy_active = true
	yield(get_tree().create_timer(2.0), "timeout")
	var doremy_dialogue = Dialogic.start("DoremyX")
	add_child(doremy_dialogue)


func quit():
	get_tree().quit()
