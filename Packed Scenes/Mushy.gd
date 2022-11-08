extends KinematicBody2D


var velocity = Vector2.ZERO
export var speed = 100
var inhurt = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	velocity.y += 4000*delta
	velocity = move_and_slide(velocity, Vector2.UP)







func _on_hurtbox_area_exited(area):
	if area.is_in_group("Player"):
		#$hitbox/CollisionShape2D.disabled = true
		$hitbox.monitorable = false
		

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player") and area.get_parent().position.y < position.y:
		$hurtbox.monitorable = false
		area.get_parent().velocity.y -= area.get_parent().jump
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite, "animation_finished")
		queue_free()
		
