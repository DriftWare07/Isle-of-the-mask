extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(200,0)
var img = load("res://assets/hazards/Bullet.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = img


func _physics_process(_delta):
	velocity = move_and_slide(velocity)



func _on_Area2D_body_entered(_body):
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()
