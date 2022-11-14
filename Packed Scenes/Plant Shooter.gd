extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Plant_Shooter_area_entered(area):
	if area.is_in_group("Player"):
		$AnimatedSprite.play("hit")
		$AudioStreamPlayer.play()
		yield($AnimatedSprite, "animation_finished")
		queue_free()
