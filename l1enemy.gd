extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randi() % 4
	if rand == 1:
		__shoot()
		look_at_player = true
	elif rand == 2:
		__shoot_4()
		look_at_player = true
	elif rand == 3:
		__shoot_2()
	else:
		__shoot_5()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if look_at_player:
		global_rotation = (player.global_position - global_position).angle()
	else:
		global_rotation_degrees += 1


func __shoot():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		shoot_at_player(0, 200)
		yield(get_tree().create_timer(0.6), "timeout")


func __shoot_2():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		shoot_circle(6, 0, 250)
		yield(get_tree().create_timer(1.0), "timeout")


func __shoot_3_d(): # Deprecated
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(10):
			shoot_circle(6, deg2rad(i*360/25.0))
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.5), "timeout")


func __shoot_4():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(4):
			shoot_at_player(deg2rad(i * 20), 200)
			shoot_at_player(deg2rad(-i * 20), 200)
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.5), "timeout")


func __shoot_5():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		var rand := randf() * 360
		shoot_at_player(deg2rad(rand), 225)
		shoot_at_player(deg2rad(-rand), 225)
		yield(get_tree().create_timer(0.4), "timeout")
