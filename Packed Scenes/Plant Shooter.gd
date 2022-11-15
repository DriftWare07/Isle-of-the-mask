extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var b = preload("res://Packed Scenes/Bullet.tscn")
var bullet = b.instance()
export var flipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.flip_h = flipped

func _physics_process(delta):
	if $ShootTimer.time_left < 1:
		bullet = b.instance()
		$AnimatedSprite.play("attack")
		
		bullet.set_global_position($Position2D.global_position)
		if flipped:
			bullet.velocity.x = 200
		else:
			bullet.velocity.x = -200
		$ShootTimer.start()
		yield($AnimatedSprite, "animation_finished")
		var bs = get_parent().add_child(bullet)
		
		
		$AnimatedSprite.play("idle")


func _on_Plant_Shooter_area_entered(area):
	if area.is_in_group("Player"):
		$AnimatedSprite.play("hit")
		$AudioStreamPlayer.play()
		yield($AnimatedSprite, "animation_finished")
		queue_free()
