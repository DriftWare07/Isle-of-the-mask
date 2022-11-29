extends KinematicBody2D


var velocity = Vector2.ZERO
export var speed = 100
var inhurt = false
onready var wallcheck = $Wallcheck
# Called when the node enters the scene tree for the first time.
var b = preload("res://Packed Scenes/Bullet.tscn")
var bullet = b.instance()
export var flipped = false
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	velocity.x = sign(wallcheck.cast_to.x)*speed
	if wallcheck.is_colliding() or not $Edgecheck.is_colliding():
		wallcheck.cast_to.x = wallcheck.cast_to.x*-1
		$Edgecheck.cast_to.x = $Edgecheck.cast_to.x*-1
	if wallcheck.cast_to.x > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	if $ShootTimer.time_left < 1:
		bullet = b.instance()
		$AnimatedSprite.play("attack")
		
		bullet.set_global_position($Position2D.global_position)
		if $AnimatedSprite.flip_h:
			bullet.velocity.x = 200
		else:
			bullet.velocity.x = -200
		$ShootTimer.start()
		
		get_parent().add_child(bullet)
		
		
		$AnimatedSprite.play("walk")
	
	
	
	
	velocity.y += 4000*delta
	velocity = move_and_slide(velocity, Vector2.UP)







func _on_hitbox_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().position.y < position.y:
		#$hurtbox.monitorable = false
		area.get_parent().velocity.y -= area.get_parent().jump
		velocity.x = 0
		$hurtsfx.play()
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
		
