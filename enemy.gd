extends Node2D
class_name Enemy


var player: Node2D
var dead := false
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
		shoot_circle()
		yield(get_tree().create_timer(0.5), "timeout")


func __shoot_3():
	yield(get_tree().create_timer(2.5), "timeout")
	while true:
		# warning-ignore: unused_variable
		for i in range(20):
			shoot_at_player()
			yield(get_tree().create_timer(0.075), "timeout")
		yield(get_tree().create_timer(2.5), "timeout")


func shoot_at_player():
	shoot_purple_bullet((player.global_position - global_position), 300)
	Global.score += 2


func shoot_circle():
	for i in range(8):
		shoot_purple_bullet(
				(player.global_position - global_position), 200,
				i * deg2rad(360/8) + deg2rad(360/16)
		)
		Global.score += 2


func __create_bullet_hitbox(bullet_id):
	if not Bullets.is_bullet_valid(bullet_id):
		return
	yield(get_tree().create_timer(0.5), "timeout")
	var properties := {}
	properties["transform"] = Bullets.get_bullet_property(bullet_id, "transform")
	properties["velocity"] = Bullets.get_bullet_property(bullet_id, "velocity")
	if properties["transform"] == null or properties["velocity"] == null or dead:
		return
	Bullets.release_bullet(bullet_id)
	Bullets.spawn_bullet(bullet_kit, properties)


func shoot_purple_bullet(direction: Vector2, speed: float, add_angle:float = 0):
	if dead:
		return
	var bullet_direction = direction.normalized()
	bullet_direction = bullet_direction.rotated(add_angle)
	var properties := {
		"transform": Transform2D(bullet_direction.angle(), global_position),
		"velocity": bullet_direction * speed
	}
	#Bullets.spawn_bullet(bullet_kit, properties)
	var bullet = Bullets.obtain_bullet(non_collison_kit)
	Bullets.set_bullet_property(bullet, "transform", properties["transform"])
	Bullets.set_bullet_property(bullet, "velocity", properties["velocity"])
	__create_bullet_hitbox(bullet)


func die():
	dead = true
	$Tween.interpolate_property(self, "modulate:a", modulate.a, 0, 0.3, 1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
