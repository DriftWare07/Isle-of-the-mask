extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var b = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bouncer_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().velocity.y = -area.get_parent().jump
		area.get_parent().double_jumped = false
		$AnimatedSprite.play("bounce")
		




func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("idle")
