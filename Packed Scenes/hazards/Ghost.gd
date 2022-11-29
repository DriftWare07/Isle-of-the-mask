extends KinematicBody2D


var velocity = Vector2.ZERO
export var speed = 100
var inhurt = false
onready var wallcheck = $Wallcheck
var vis = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	velocity.x = sign(wallcheck.cast_to.x)*speed
	if wallcheck.is_colliding():
		wallcheck.cast_to.x = wallcheck.cast_to.x*-1
	if wallcheck.cast_to.x > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	
	
	if $disappearence_timer.time_left < 1:
		if vis:
			$AnimationPlayer.play("disappear")
			vis = false
			$disappearence_timer.start()
		elif not vis:
			$AnimationPlayer.play("reappear")
			vis = true
			$disappearence_timer.start()
	
	
	
	velocity.y += 4000*delta
	velocity = move_and_slide(velocity, Vector2.UP)







func _on_hitbox_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().position.y < position.y:
		#$hurtbox.monitorable = false
		area.get_parent().velocity.y -= area.get_parent().jump
		velocity.x = 0
		$hurtsfx.play()
		#$disappearence_timer.stop()
		$AnimatedSprite.play("hit")
		
		yield($AnimatedSprite, "animation_finished")
		queue_free()
		
