extends Node2D
class_name Enemy


var player: Node2D
var look_at_player := false
export(Resource) var bullet_kit
export(Resource) var non_collison_kit


# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randi() % 3
	if rand == 1:
		__shoot()
		look_at_player = true
	elif rand == 2:
		__shoot_3()
		look_at_player = true
	else:
		__shoot_2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if look_at_player:
		global_rotation = (player.global_position - global_position).angle()
	else:
		global_rotation_degrees += 1


func __shoot():
	yield(get_tree().create_timer(1.0), "timeout")
	while true:
		shoot_at_player()
		yield(get_tree().create_timer(0.27), "timeout")


func __shoot_2():
	yield(get_tree().create_timer(1.0), "timeout")
	while true:
		shoot_circle()
		yield(get_tree().create_timer(0.5), "timeout")


func __shoot_3():
	yield(get_tree().create_timer(1.0), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(20):
			shoot_at_player()
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.0), "timeout")


func shoot_at_player():
	var bullet_velocity = (player.global_position - global_position).normalized()
	var properties := {
		"transform": Transform2D(bullet_velocity.angle(), global_position),
		"velocity": bullet_velocity * 300
	}
	#Bullets.spawn_bullet(bullet_kit, properties)
	var bullet = Bullets.obtain_bullet(non_collison_kit)
	Bullets.set_bullet_property(bullet, "transform", properties["transform"])
	Bullets.set_bullet_property(bullet, "velocity", properties["velocity"])
	__create_bullet_hitbox(bullet)
	Global.score += 2


func shoot_circle():
	for i in range(8):
		var bullet_velocity = (player.global_position - global_position).normalized()
		bullet_velocity = bullet_velocity.rotated(i * deg2rad(360/8) + deg2rad(360/16))
		var properties := {
			"transform": Transform2D(bullet_velocity.angle(), global_position),
			"velocity": bullet_velocity * 200
		}
		#Bullets.spawn_bullet(bullet_kit, properties)
		var bullet = Bullets.obtain_bullet(non_collison_kit)
		Bullets.set_bullet_property(bullet, "transform", properties["transform"])
		Bullets.set_bullet_property(bullet, "velocity", properties["velocity"])
		__create_bullet_hitbox(bullet)
		Global.score += 1


func __create_bullet_hitbox(bullet_id):
	if not Bullets.is_bullet_valid(bullet_id):
		return
	yield(get_tree().create_timer(0.5), "timeout")
	var properties := {}
	properties["transform"] = Bullets.get_bullet_property(bullet_id, "transform")
	properties["velocity"] = Bullets.get_bullet_property(bullet_id, "velocity")
	Bullets.release_bullet(bullet_id)
	if properties["transform"] == null or properties["velocity"] == null:
		return
	Bullets.spawn_bullet(bullet_kit, properties)
