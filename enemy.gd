extends Node2D
class_name Enemy


var player: Node2D
var dead := false
var look_at_player := false
export(Resource) var bullet_kit
export(Resource) var non_collison_kit


func shoot_at_player(add_angle := 0.0, speed := 300):
	shoot_purple_bullet((player.global_position - global_position).rotated(add_angle), speed)
	Global.score += 2


func shoot_circle(n, add_angle := 0.0, speed := 200):
	for i in range(n):
		shoot_purple_bullet(
				(player.global_position - global_position), speed,
				i * deg2rad(360/n) + deg2rad(360/(2*n) + add_angle)
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


func shoot_purple_bullet(direction: Vector2, speed: float, add_angle: float = 0):
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
