extends KinematicBody2D

var b = preload("res://Packed Scenes/hazards/Bullet.tscn")
var bullet = b.instance()

var startingpos
export var drift = 100
var driftpos = Vector2()
export var speed = 100
var inhurt = false
var lerpspeed = 0.007

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$AnimatedSprite.play("fly")
	startingpos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(_delta):
	driftpos.x = lerp(global_position.x, global_position.x + rand_range(-drift, drift), lerpspeed)
	driftpos.y = lerp(global_position.y, global_position.y + rand_range(-drift, drift), lerpspeed)
	global_position = driftpos
	
	if $Timer.time_left < 0.1:
		bullet = b.instance()
		bullet.velocity.y = 200
		bullet.velocity.x = 0
		bullet.img = load("res://assets/hazards/Bee Bullet.png")
		bullet.set_global_position(global_position)
		$AnimatedSprite.play("attack")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("fly")
		get_parent().add_child(bullet)
		
		$Timer.start()







func _on_hitbox_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().position.y < position.y:
		#$hurtbox.monitorable = false
		area.get_parent().velocity.y -= area.get_parent().jump
		
		$hurtsfx.play()
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
		
