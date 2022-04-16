extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randi() % 5
	if rand == 1:
		__shoot()
		look_at_player = true
	elif rand == 2:
		__shoot_3()
		look_at_player = true
	elif rand == 3:
		__shoot_4()
		look_at_player = true
	elif rand == 4:
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
		shoot_at_player()
		yield(get_tree().create_timer(0.27), "timeout")


func __shoot_2():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		shoot_circle(8)
		yield(get_tree().create_timer(0.5), "timeout")


func __shoot_3():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(25):
			shoot_at_player()
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.5), "timeout")


func __shoot_4():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(15):
			shoot_at_player(deg2rad(30))
			shoot_at_player(deg2rad(-30))
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.5), "timeout")


func __shoot_5():
	yield(get_tree().create_timer(2.5), "timeout")
	var i := 0
	while true:
		shoot_circle(3, deg2rad(i))
		yield(get_tree().create_timer(0.3), "timeout")
		if i > 360:
			i = 0
		else:
			i += 360/10
