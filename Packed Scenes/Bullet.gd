extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(200,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	velocity = move_and_slide(velocity)



func _on_Area2D_body_entered(body):
	queue_free()
