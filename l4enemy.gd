extends Enemy
class_name L4Enemy


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
		__shoot_3()
		look_at_player = true
	elif rand == 3:
		__shoot_2()
	else:
		__shoot_5()


func __shoot():
	yield(get_tree().create_timer(2.5), "timeout")
	# warning-ignore: unused_variable
	for i in range(8):
		shoot_at_player(deg2rad(i * 10))
		shoot_at_player(deg2rad(-i * 10))
		yield(get_tree().create_timer(0.075), "timeout")
	yield(get_tree().create_timer(2.5), "timeout")
	die()


func __shoot_2():
	yield(get_tree().create_timer(2.5), "timeout")
	for i in range(5):
		shoot_circle(10, 0, 300 - i * 40)
	yield(get_tree().create_timer(2.5), "timeout")
	die()


func __shoot_3():
	yield(get_tree().create_timer(2.5), "timeout")
	# warning-ignore: unused_variable
	for i in range(10):
		shoot_at_player(deg2rad(5))
		shoot_at_player()
		shoot_at_player(deg2rad(-5))
		yield(get_tree().create_timer(0.075), "timeout")
	yield(get_tree().create_timer(2.5), "timeout")
	die()
	


func __shoot_4_d(): # Deprecated
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(10):
			shoot_at_player(deg2rad(30))
			shoot_at_player(deg2rad(-30))
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.5), "timeout")


func __shoot_5():
	yield(get_tree().create_timer(2.5), "timeout")
	# warning-ignore: unused_variable
	for i in range(10):
		shoot_circle(6, deg2rad(i*360/25.0))
		yield(get_tree().create_timer(0.075), "timeout")
	yield(get_tree().create_timer(2.5), "timeout")
	die()



func __shoot_5_d(): # Deprecated
	yield(get_tree().create_timer(2.5), "timeout")
	var i := 0
	while true:
		shoot_circle(3, deg2rad(i))
		yield(get_tree().create_timer(0.3), "timeout")
		if i > 360:
			i = 0
		else:
			i += 360/10


func die():
	Global.score += 10
	dead = true
	$Tween.interpolate_property(self, "modulate:a", modulate.a, 0, 0.3, 1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()


func __create_bullet_hitbox(bullet_id):
	if not Bullets.is_bullet_valid(bullet_id):
		return
	yield(get_tree().create_timer(0.6), "timeout")
	var properties := {}
	properties["transform"] = Bullets.get_bullet_property(bullet_id, "transform")
	properties["velocity"] = Bullets.get_bullet_property(bullet_id, "velocity")
	if properties["transform"] == null or properties["velocity"] == null or dead:
		return
	Bullets.release_bullet(bullet_id)
	Bullets.spawn_bullet(bullet_kit, properties)
